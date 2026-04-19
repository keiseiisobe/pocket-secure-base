"""Strategic route planning via Gemini + ODPT data + optional Google Search grounding."""

from __future__ import annotations

import asyncio
import logging

from google import genai
from google.genai import types

from app.schemas import GeminiPlanPayload, PlanRequest, PlanResponse, RationaleItem, Waypoint
from app.services.maps_url import GOOGLE_MAPS_MAX_WAYPOINTS, build_google_maps_navigate_url
from app.services.odpt import fetch_tokyo_metro_train_information
from app.settings import Settings

logger = logging.getLogger(__name__)


def build_mock_plan(request: PlanRequest, tool_metadata: dict[str, str]) -> PlanResponse:
    """Deterministic fallback for local development without a Gemini API key."""

    tool_metadata = {**tool_metadata, "planner_mode": "mock_without_gemini_key"}
    overview = (
        "This is an offline placeholder plan. Configure GEMINI_API_KEY on the server for live "
        "sensory-aware routing. The URL below demonstrates Google Maps handoff with intermediate waypoints."
    )
    origin = request.origin.strip() if request.origin.strip() else ""
    destination = request.destination.strip()
    waypoints: list[Waypoint] = [
        Waypoint(
            label="Side-street preference (example tactical point)",
            address="Yushima Seido, Bunkyo City, Tokyo",
        ),
        Waypoint(
            label="Buffer near park space (example)",
            address="Shinobazu Pond, Taito City, Tokyo",
        ),
    ]
    travel = "walking"
    url = build_google_maps_navigate_url(
        destination=destination,
        waypoints=[w.address for w in waypoints],
        origin=origin or None,
        travel_mode=travel,
    )
    return PlanResponse(
        route_overview=overview,
        rationale_items=[
            RationaleItem(
                title="Why this placeholder is shown",
                detail="The strategic planner requires GEMINI_API_KEY and returns a deterministic example path for UI testing.",
            ),
            RationaleItem(
                title="Sensory preferences you sent",
                detail=", ".join(request.sensory_preferences)
                if request.sensory_preferences
                else "(none)",
            ),
        ],
        waypoints=waypoints,
        travel_mode=travel,
        navigation_url=url,
        tool_metadata=tool_metadata,
    )


def _recon_prompt(request: PlanRequest, odpt_summary: str) -> str:
    prefs = ", ".join(request.sensory_preferences) if request.sensory_preferences else "(none specified)"
    origin = request.origin.strip() or "not specified — assume user current location in Google Maps"
    return f"""You are assisting with sensory-aware walking route planning in Tokyo.

Origin (text): {origin}
Destination (text): {request.destination.strip()}
Sensory preferences (tokens): {prefs}

Tokyo Metro / ODPT rail status (may be empty):
{odpt_summary}

Use Google Search as needed. Identify construction, festivals, demonstrations, nightlife clusters, markets, major tourist attractions, or other sources of noise or crowding that could affect walking between origin and destination (today / near term).

Respond with at most 8 bullet points of plain text. Note uncertainty where needed."""


def _plan_prompt(request: PlanRequest, odpt_summary: str, recon_notes: str) -> str:
    prefs = ", ".join(request.sensory_preferences) if request.sensory_preferences else "(none specified)"
    origin = request.origin.strip() or "device location"
    return f"""You are DeepBreath's Strategic Planner. Produce tactical walking route guidance.

Origin: {origin}
Destination: {request.destination.strip()}
Sensory preferences: {prefs}

Tokyo Metro rail status (ODPT server prefetch):
{odpt_summary}

Environmental search notes (may be incomplete):
{recon_notes if recon_notes.strip() else "(no additional search notes)"}

Requirements:
- Prefer fewer sensory triggers over absolute shortest distance.
- Emit at most {GOOGLE_MAPS_MAX_WAYPOINTS} tactical waypoints (addresses or well-known Tokyo place names Google Maps can resolve).
- Each waypoint must include a short label explaining why it steers away from hazards (noise, crowds, harsh lighting context as applicable).
- travel_mode is usually walking for this MVP.

Output must follow the JSON schema exactly (you are writing JSON only)."""


def _parse_plan_json(text: str | None) -> GeminiPlanPayload:
    if not text or not text.strip():
        raise ValueError("empty model output")
    return GeminiPlanPayload.model_validate_json(text)


def _generate_recon_sync(
    client: genai.Client, model_id: str, request: PlanRequest, odpt_summary: str
) -> tuple[str, str]:
    status = "ok"
    notes = ""
    try:
        response = client.models.generate_content(
            model=model_id,
            contents=_recon_prompt(request, odpt_summary),
            config=types.GenerateContentConfig(
                tools=[types.Tool(google_search=types.GoogleSearch())],
                temperature=0.35,
                max_output_tokens=1024,
            ),
        )
        notes = response.text or ""
    except Exception as exc:
        logger.warning("Google Search recon failed: %s", exc)
        status = repr(exc)
    return notes, status


def _generate_plan_sync(
    client: genai.Client, model_id: str, request: PlanRequest, odpt_summary: str, recon_notes: str
) -> GeminiPlanPayload:
    schema = GeminiPlanPayload.model_json_schema()
    response = client.models.generate_content(
        model=model_id,
        contents=_plan_prompt(request, odpt_summary, recon_notes),
        config=types.GenerateContentConfig(
            response_mime_type="application/json",
            response_json_schema=schema,
            temperature=0.25,
            max_output_tokens=2048,
        ),
    )
    return _parse_plan_json(response.text)


async def run_strategic_planner(request: PlanRequest, settings: Settings) -> PlanResponse:
    tool_metadata: dict[str, str] = {}

    odpt_summary, odpt_meta = await fetch_tokyo_metro_train_information(settings.odpt_consumer_key)
    tool_metadata["odpt_status"] = str(odpt_meta.get("status", ""))

    if not settings.gemini_api_key:
        return build_mock_plan(request, tool_metadata)

    client = genai.Client(api_key=settings.gemini_api_key)
    model_id = settings.gemini_model

    recon_notes, recon_status = await asyncio.to_thread(
        _generate_recon_sync, client, model_id, request, odpt_summary
    )
    tool_metadata["google_search_recon"] = recon_status if recon_status == "ok" else recon_status

    try:
        payload = await asyncio.to_thread(
            _generate_plan_sync, client, model_id, request, odpt_summary, recon_notes
        )
    except Exception as exc:
        logger.exception("Structured plan generation failed; using mock plan: %s", exc)
        tool_metadata["planner_error"] = repr(exc)
        return build_mock_plan(request, tool_metadata)

    trimmed = payload.waypoints[:GOOGLE_MAPS_MAX_WAYPOINTS]
    url = build_google_maps_navigate_url(
        destination=request.destination.strip(),
        waypoints=[w.address for w in trimmed],
        origin=request.origin.strip() or None,
        travel_mode=payload.travel_mode,
    )
    return PlanResponse(
        route_overview=payload.route_overview,
        rationale_items=payload.rationale_items,
        waypoints=trimmed,
        travel_mode=payload.travel_mode,
        navigation_url=url,
        tool_metadata=tool_metadata,
    )

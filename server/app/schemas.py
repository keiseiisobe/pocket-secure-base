"""API and planner JSON payloads."""

from typing import Literal

from pydantic import BaseModel, Field


class PlanRequest(BaseModel):
    origin: str = Field(
        ...,
        description="Human-readable origin (address or landmark). Empty means let Maps use device location.",
    )
    destination: str = Field(..., description="Human-readable destination.")
    sensory_preferences: list[str] = Field(
        default_factory=list,
        description=(
            "Preference tokens from the client, e.g. avoid_loud_areas, "
            "avoid_crowds, avoid_bright_light."
        ),
    )


class RationaleItem(BaseModel):
    title: str
    detail: str


class Waypoint(BaseModel):
    label: str = Field(..., description="Short label shown in the route overview.")
    address: str = Field(..., description="Waypoint address for Google Maps.")


class PlanResponse(BaseModel):
    route_overview: str = Field(..., description="Human-readable explanation of the chosen path.")
    rationale_items: list[RationaleItem] = Field(default_factory=list)
    waypoints: list[Waypoint] = Field(default_factory=list)
    travel_mode: Literal["walking", "driving", "bicycling", "transit"] = "walking"
    navigation_url: str = Field(..., description="Android/iOS Maps URL scheme handoff.")
    tool_metadata: dict[str, str] = Field(
        default_factory=dict,
        description="Best-effort notes about ODPT / grounding availability.",
    )


class GeminiPlanPayload(BaseModel):
    """Structured output from Gemini for the tactical plan (no URL)."""

    route_overview: str
    rationale_items: list[RationaleItem]
    waypoints: list[Waypoint] = Field(default_factory=list, max_length=9)
    travel_mode: Literal["walking", "driving", "bicycling", "transit"] = "walking"

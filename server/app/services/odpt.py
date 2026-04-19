"""ODPT (Tokyo) open data: train status and delay information.

Falls back gracefully when the API is unavailable, rate-limited, or the
consumer key is missing. See https://developer.odpt.org/
"""

import logging
from typing import Any

import httpx

logger = logging.getLogger(__name__)

ODPT_BASE_V4 = "https://api.odpt.org/api/v4"


async def fetch_tokyo_metro_train_information(consumer_key: str | None) -> tuple[str, dict[str, Any]]:
    """Returns human-readable ODPT summary plus structured metadata."""

    meta: dict[str, Any] = {"provider": "ODPT", "status": "skipped"}

    if not consumer_key:
        meta["status"] = "skipped_no_consumer_key"
        return (
            "ODPT: no consumer key configured; train delay and operator status were not fetched.",
            meta,
        )

    path = f"{ODPT_BASE_V4}/odpt:TrainInformation"
    params: dict[str, str] = {
        "odpt:operator": "odpt:Operator:TokyoMetro",
        "acl:consumerKey": consumer_key,
    }
    try:
        async with httpx.AsyncClient(timeout=12.0) as client:
            response = await client.get(path, params=params)
            response.raise_for_status()
            data = response.json()
    except httpx.HTTPStatusError as exc:
        meta["status"] = "http_error"
        meta["detail"] = str(exc.response.status_code)
        logger.warning("ODPT HTTP error: %s", exc)
        return (
            "ODPT train information could not be retrieved (HTTP error). Proceed without live rail status.",
            meta,
        )
    except (httpx.RequestError, ValueError, TypeError) as exc:
        meta["status"] = "request_error"
        meta["detail"] = repr(exc)
        logger.warning("ODPT request failed: %s", exc)
        return (
            "ODPT train information could not be retrieved (network or parse error). Proceed without live rail status.",
            meta,
        )

    meta["status"] = "ok"
    lines = _summarize_train_information_payload(data)
    summary = (
        "Tokyo Metro operator reports (ODPT TrainInformation):\n"
        + ("\n".join(lines) if lines else "(No active disruption records in the response payload.)")
    )
    return summary, meta


def _summarize_train_information_payload(data: Any) -> list[str]:
    """Extract short lines from ODPT JSON-LD style responses."""

    lines: list[str] = []
    records = data if isinstance(data, list) else [data]
    for item in records:
        if not isinstance(item, dict):
            continue
        odpt_line = item.get("odpt:railway") or item.get("owl:sameAs")
        title = (
            item.get("dc:title")
            or item.get("odpt:trainInformationTitle")
            or item.get("dct:title")
        )
        body = (
            item.get("odpt:trainInformationText")
            or item.get("schema:description")
            or item.get("dct:description")
        )
        parts = [p for p in (title, body) if isinstance(p, str) and p.strip()]
        if not parts:
            continue
        prefix = ""
        if isinstance(odpt_line, str) and odpt_line:
            prefix = f"[{odpt_line.split('/')[-1]}] "
        lines.append(prefix + " — ".join(parts))

    return lines[:20]

"""Build Google Maps directions URLs with tactical waypoints (max 9)."""

from urllib.parse import quote, urlencode

# Documented multi-stop URL constraint used across DeepBreath clients.
GOOGLE_MAPS_MAX_WAYPOINTS = 9


def build_google_maps_navigate_url(
    *,
    destination: str,
    waypoints: list[str],
    origin: str | None,
    travel_mode: str,
) -> str:
    trimmed = [w.strip() for w in waypoints if w.strip()][:GOOGLE_MAPS_MAX_WAYPOINTS]
    params: dict[str, str] = {
        "api": "1",
        "destination": destination.strip(),
        "travelmode": travel_mode,
        "dir_action": "navigate",
    }
    if origin and origin.strip():
        params["origin"] = origin.strip()
    if trimmed:
        params["waypoints"] = "|".join(trimmed)
    query = urlencode(params, quote_via=quote)
    return f"https://www.google.com/maps/dir/?{query}"

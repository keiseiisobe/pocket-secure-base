# External Navigation: Google Maps URL Launcher

## 1. Overview
Instead of just embedding a static map, our app uses the `url_launcher` package to hand off complex navigation tasks to the native Google Maps application. This allows users to benefit from full turn-by-turn guidance, real-time traffic, and localized transit data.

## 2. What We CAN Specify (URL Parameters)
Using the [Google Maps URLs API](https://developers.google.com/maps/documentation/urls/get-started), we can programmatically define the following:

| Requirement | Parameter | Description |
| :--- | :--- | :--- |
| **"Where we go"** | `origin`, `destination` | Supports addresses, place names, or `lat,lng` coordinates. |
| **"Which way we go"** | `travelmode` | Can be set to `walking`, `transit`, `driving`, or `bicycling`. |
| **"Safe Stops"** | `waypoints` | A list of locations to "steer" the route. Includes **Strategic** (Safe Havens to rest) and **Tactical** (quiet corners to avoid crowds). |
| **"Avoidance"** | `avoid` | Can specify features to avoid, such as `tolls`, `highways`, or `ferries`. |
| **"Action"** | `dir_action=navigate` | Forces the app to start turn-by-turn navigation immediately. |

### Example URL:
`https://www.google.com/maps/dir/?api=1&origin=Current+Location&destination=Home&waypoints=Safe+Haven+A;Safe+Haven+B&travelmode=walking&dir_action=navigate`

---

## 3. What We CANNOT Do (Limitations)
While powerful, the URL launcher method has specific constraints:

- **Waypoint Count Limit (Important for Ueno Park route sample)**:
  - Google Maps URLs (`/maps/dir/?api=1`) support **up to 9 waypoints**.
  - Our Ueno Park sample route intentionally requests **10 waypoints** to show this limit visually.
  - In the sample app, we expose this with explicit variables:
    - `googleMapsUrlMaxWaypoints = 9`
    - `requestedWaypointsToUenoPark.length = 10`
    - `isRequestedWaypointCountWithinGoogleMapsLimit` (boolean)
  - If requested waypoints exceed the limit, the launcher trims waypoints to the first 9 before creating the URL (`launchableWaypoints`).
  - This makes the limitation transparent in the UI and avoids generating a non-functional URL.

- **"When we go" (Departure/Arrival Time)**:
  - The standard Google Maps URL scheme (`api=1`) **does not officially support** passing a specific departure or arrival time. 
  - While "hacky" internal URL formats exist, they are brittle and not recommended for production.
  - **Workaround**: The app's LLM can suggest the best time *within our UI*, but once the user is handed off to Google Maps, they must manually adjust the time in the Google Maps "Options" menu if they wish to see future schedules.
- **Custom Routing Logic**:
  - We cannot force Google Maps to take a "quiet" or "well-lit" street unless we explicitly provide every single turn as a **waypoint**.
  - Google Maps will always default to its own "Fastest" or "Recommended" path between the waypoints we provide.
- **Bi-directional Communication**:
  - Once the user leaves our app to go to Google Maps, our app **cannot** track their progress or know if they have arrived safely. 
  - We rely on the user returning to our app or background location tracking (if implemented separately).
- **Dynamic Updates**:
  - We cannot change the destination or add waypoints *after* the Google Maps app has been launched without launching a brand new URL (which interrupts the user's current session).

---

## 4. Summary
We use Google Maps as the **"Heavy Lifter"** for navigation. Our app handles the **Strategic Planning** (choosing the safe destination and waypoints), while Google Maps handles the **Tactical Execution** (giving the user the actual directions).

# Cloud AI Architecture: The Strategic Agent (Planning Phase)

## 1. Role & Objective
The Cloud AI acts as the **Strategic Planner** for the Pocket Secure Base. Its primary goal is to transform a simple user request (e.g., "I want to go to the park") into a detailed, sensory-aware navigation plan. 

While the Local AI handles "Tactical" immediate safety, the Cloud AI handles the "Strategic" deep-reasoning tasks that require internet access and high compute power.

---

## 2. The Agentic Workflow
The Cloud AI employs an **Agentic Loop** (Reason -> Act -> Observe). It does not just return a route; it investigates the environment using external tools before finalizing the plan.

```mermaid
graph TD
    UserReq[User: 'Go to Ueno via quiet route'] --> Agent{Cloud AI Agent}
    Agent -- "1. Tool Call" --> ODPT[ODPT API: Train Crowds]
    Agent -- "2. Tool Call" --> GSearch[Google Search: Local Events]
    ODPT --> Agent
    GSearch --> Agent
    Agent -- "3. Synthesis" --> Plan[Final Plan Generation]
    Plan --> JSON[Output: Waypoints + Sensory Map JSON]
    JSON --> App[Flutter Mobile App]
```

---

## 3. Strategic Tools (Function Calling)
The LLM is equipped with specialized functions to "see" the current state of the city:

| Tool Name | Parameters | Description |
| :--- | :--- | :--- |
| `get_transit_status` | `line_name`, `station` | Accesses Tokyo Metro GTFS-RT (ODPT) to check for delays and platform crowding. |
| `search_local_events` | `location`, `date` | Uses Google Search to identify festivals, construction, or protests that create noise/crowds. |
| `get_sensory_data` | `coordinates` | Queries the proprietary sensory database for permanent triggers (echoing tunnels, loud AC exhausts). |
| `calculate_quiet_route` | `origin`, `destination` | Performs initial pathfinding with weightings for "Quiet" vs "Fast". |

---

## 4. Output: The "Strategic Handover"
The final result of the Strategic Planning phase is a structured payload sent to the mobile app, containing two core components:

### A. The Navigation URL
A Google Maps URL optimized with **Tactical Waypoints** to force the native maps app to stick to the quiet path identified by the LLM.

### B. The Sensory Map (JSON)
A list of specific coordinates where the **Local Guardian** should be extra vigilant.
```json
{
  "sensory_map": [
    {
      "lat": 35.7135,
      "lng": 139.7766,
      "type": "noise_risk",
      "instruction": "Construction site nearby. Stay on the right side of the street."
    },
    {
      "lat": 35.7111,
      "lng": 139.7699,
      "type": "safe_haven",
      "instruction": "Quiet public library 20m ahead if you need to rest."
    }
  ]
}
```

---

## 5. Implementation Stack
- **Model**: Gemini 2.0 Flash (for speed and native tool-use).
- **Framework**: LangGraph or FastAPI for orchestrating the tool-calling loop.
- **Latency Target**: < 5 seconds for full strategic analysis and route generation.

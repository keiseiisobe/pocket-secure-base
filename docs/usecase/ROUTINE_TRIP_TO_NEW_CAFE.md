# Use Case: Journey to a New Cafe (The "Last Mile" Support)

## 1. Situation
The user is meeting a friend at a new cafe. While they are curious about the destination, their primary anxiety is the **journey itself**: navigating unfamiliar streets, crossing busy intersections, and the potential for "sensory surprises" along the way.

## 2. System Intervention

### A. Sensory-Aware Route Planning
- **User Action**: Enters the cafe name into the "Secure Base" planner.
- **Cloud LLM**: Uses the **Google Search Tool** and **Maps API** to analyze the route. It identifies that the shortest path goes through a loud construction zone and a crowded shopping arcade.
- **Action**: The LLM picks a **Tactical Route** that uses residential backstreets. It adds 4 minutes to the walk but reduces noise exposure by an estimated 60%.

### B. Proactive Movement Guidance
- **Departure Briefing**: Before the user leaves, the app provides a "sensory map" of the walk: *"We're taking the quiet backstreets today. There’s one busy crossing at the 5-minute mark, but after that, it’s a peaceful residential walk all the way to the cafe."*
- **Verbal "Guardian" (In-Transit)**: As the user approaches the busy crossing, the app speaks via headphones: *"We're coming up to the only loud part of the walk. It will take about 30 seconds to cross. You're doing great."*

### C. Tactical Waypoints
- **Navigation**: The LLM injects a "Tactical Waypoint" at a quiet corner to force Google Maps to stay on the residential path, preventing it from rerouting the user back to the loud main road.

## 3. Outcome
The user arrives at the cafe with their "sensory battery" still full. Because the journey was managed and predictable, they have the energy to enjoy the social interaction at the destination.

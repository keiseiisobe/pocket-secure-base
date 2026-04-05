# Cost Estimates: Pocket Secure Base

Based on the system architecture and service overview for **Pocket Secure Base**, the app relies on external APIs (Google Search, Transit Data) and Cloud LLMs for routing, real-time environment analysis, and tool use.

The following is an estimated daily cost breakdown assuming **1,000 Daily Active Users (DAU)**.

## Assumptions per 1,000 Users / Day
*   **Trips:** Each user makes an average of 2 guided trips per day. Total: **2,000 trips/day**.
*   **LLM Usage:** 5 LLM interactions per trip (initial planning, analyzing transit data, finding Safe Havens via search, and real-time rerouting). Total: **10,000 LLM calls/day**.
*   **Token Usage:** Average of 1,000 input tokens and 500 output tokens per call (10M input / 5M output tokens daily).
*   **Google Maps:** Navigation is handled for free by launching native OS maps apps via URL Schemes/Intents. No Google Maps APIs are used.
*   **Google Search Tool:** Used for both environmental context (events/construction) and identifying "Safe Havens" by searching for quiet locations and reading reviews. Estimated 3 Search API calls per trip. Total: **6,000 requests/day**.
*   **Transit Data (ODPT):** Tokyo Metro Open Data Challenge APIs are generally free but require backend processing.

## Estimated Daily Cost Breakdown

| Service | Estimated Usage (per day) | Low-End Estimate (Flash/Basic) | High-End Estimate (Pro/Advanced) |
| :--- | :--- | :--- | :--- |
| **Cloud LLM** | 10,000 calls (15M total tokens) | **~$2.50** *(e.g., Gemini 1.5 Flash)* | **~$125.00** *(e.g., Gemini 1.5 Pro or GPT-4o)* |
| **Google Search API** | 6,000 requests | **$30.00** | **$30.00** |
| **Backend Infra & DB** | Serverless compute & DB | **$5.00** | **$15.00** |
| **Total Daily Cost** | | **~$37.50 / day** | **~$170.00 / day** |
| **Total Monthly Cost**| | **~$1,125 / month** | **~$5,100 / month** |

## Strategic Recommendations to Lower Costs

1.  **Aggressive Caching:** Do not hit the Google Search Tool every time a user walks down a popular street. Cache "Safe Haven" data (coordinates and sensory tags) and local event data in your own database (e.g., Firebase/Supabase) based on location and time-to-live (TTL).
2.  **Rely on the Local AI:** The architecture includes a "Local AI (The Guardian)". Pushing as much verbal feedback, grounding, and real-time monitoring to the on-device model will save massive amounts of Cloud LLM costs, as on-device inference is completely free.
3.  **Tiered LLM Routing:** Use a cheap, fast model (like Gemini 1.5 Flash) to parse structured transit data (ODPT), and only invoke the expensive reasoning models (like Gemini 1.5 Pro) if a complex sensory conflict or emergency is detected on the route.
4.  **Open Source Alternatives:** Use OpenStreetMap (OSM) / Overpass API for finding basic parks, benches, or quiet zones to use as waypoints, as open-source mapping data is free and often sufficient for pedestrian routing.

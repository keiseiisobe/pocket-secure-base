# Project Analysis: Feasibility, Value & Risk

## 1. Technical Feasibility: [Feasible but Complex]
The core components are technically possible today, but the "glue" that connects them in real-time is the challenge.

- **The "Easy" Parts**: Integrating Google Search for place discovery, implementing haptic breathing exercises, and building a basic SOS trigger are standard mobile development tasks.
- **The "Hard" Parts**:
    - **LLM Latency**: Waiting for an LLM to "search" and process a route while a user is walking can take 5–15 seconds. In a navigation context, this feels like an eternity.
    - **Data Granularity**: While Tokyo Metro provides GTFS-RT data, "noise levels" and "crowd density" on specific street corners are not always available in real-time. You would likely need to rely on *probabilistic* data (e.g., "this area is usually busy at 5 PM") rather than 100% real-time accuracy.
    - **Background Execution**: Mobile OS (iOS/Android) limits what apps can do in the background to save battery. Keeping an LLM-driven "verbal guide" active while Google Maps is in the foreground requires careful handling of Background App Refresh and Audio session permissions.

## 2. Value for Target Audience: [High]
For individuals with ASD, ADHD, or SPS, this tool addresses "Environmental Unpredictability," which is a primary source of anxiety.

- **Autonomy**: By providing a "Secure Base," the app allows users to attempt journeys they might otherwise avoid, fostering independence.
- **Sensory Management**: Traditional navigation (Google/Apple Maps) optimizes for *speed*. This app optimizes for *mental health*, which is a massive underserved market.
- **Grounding Tools**: Having haptic/audio grounding pre-integrated into a navigation tool is clever because the "crisis" (panic) often happens *during* the transition between locations.

## 3. Potential Problems & Risks
- **The "App Uninstall Problem"**: Large AI models (multi-GB) and heavy processing can lead to uninstalls due to:
    - **Storage Bloat**: Users with low-storage devices may delete the app to reclaim space.
    - **Battery & Heat**: Sustained NPU/CPU usage for real-time monitoring can cause device heating and rapid battery drain, leading to user frustration.
- **The "Trust Gap"**: If the app fails to detect sudden sensory triggers (e.g., unexpected construction), a single failure can lead to a complete loss of trust.
- **Connectivity Issues**: Subway "dead zones" are a critical failure point for cloud-only solutions.
- **Cognitive Overload**: Too much feedback can become a sensory trigger itself.

## 4. Strategic Recommendations
- **Reflex-Based Hybrid AI**: 
    - Default to **Gemini 2.0 Flash (Cloud)** for complex planning and emotive guidance when online.
    - Utilize a **Bundled Reflex Engine** (Tiny Classifier + Audio Assets) for 100% reliable, zero-latency emergency support offline.
- **Micro-Asset Management**: Use highly compressed Opus audio and quantized TFLite/CoreML models to keep the total app size under 200MB, allowing safety features to be bundled by default.
- **Adaptive "Sentry" Logic**: Use extremely low-power monitoring to trigger the Reflex Engine, minimizing battery drain.
- **User-Defined "Safe Haven" Crowdsourcing**: Create a proprietary sensory map that Google Maps lacks.
- **Offline "Panic" Mode**: Guarantee grounding tools work 100% offline.

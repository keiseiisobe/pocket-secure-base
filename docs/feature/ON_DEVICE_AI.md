# Feature Specification: On-Device AI ("The Guardian")

## 1. Overview
"The Guardian" is the on-device intelligence layer of the Pocket Secure Base. It consists of two local AI models—a lightweight LLM for text generation and a high-quality TTS engine—working in tandem to provide immediate, offline-capable sensory support during navigation.

---

## 2. The Remote-to-Local Navigation Flow
The system operates on a "Strategic Cloud, Tactical Local" model. The Cloud AI handles the heavy planning, while the Local AI handles real-time execution and safety.

```mermaid
sequenceDiagram
    participant User
    participant App as AI Orchestrator (App)
    participant LocalAI as Local LLM (Tactical)
    participant LocalTTS as Local TTS (Voice)
    participant CloudAI as Cloud LLM (Strategic)
    participant CloudTTS as Cloud TTS (Voice)
    participant NativeMaps as Google Maps (External)

    Note over User, CloudAI: Phase 1: Strategic Planning
    User->>App: "Go to Cafe via quiet route"
    App->>CloudAI: Request Plan & Search Environment
    CloudAI-->>CloudAI: Analyze ODPT & Search
    CloudAI->>App: Send Plan + Sensory Map
    App->>User: Show Safety Briefing & Route Overview
    App->>NativeMaps: Launch via URL Scheme (Waypoints)

    Note over User, NativeMaps: Phase 2: Tactical Navigation (The Guardian)
    NativeMaps->>User: Standard Directions
    
    rect rgb(240, 248, 255)
        Note right of App: Background Sentry (Low-Power)
        App->>App: Monitor GPS + Ambient Noise
        App->>App: Match Location with Sensory Map
        
        alt If Connection is Strong (Normal)
            App->>CloudAI: Get Situational Advice
            CloudAI->>CloudTTS: Stream Audio
            CloudTTS->>User: (Audio) "Stay on the quiet path..."
        else If Connection is Weak / High Stress (Guardian)
            App->>LocalAI: Trigger "Guardian" Intervention
            LocalAI->>LocalTTS: Stream: "Busy road ahead, stay right."
            LocalTTS->>User: (Audio) "Busy road ahead..."
        end
    end
```

---

## 3. Core Models & Assets

### A. Local LLM (Reasoning)
- **Model Choice**: **gemma-3-1b** (via `onnxruntime` or `LiteRT`).
- **Role**: Takes raw environmental data (noise, GPS) and route metadata to generate immediate advice when internet is weak or timing is critical.
- **Latency**: Sub-200ms TTFT (Time-to-First-Token) is the target for immediate intervention.

### B. Local TTS (The Voice)
- **Model Choice**: **Kokoro-82m**.
- **Role**: Transforms the Local LLM's text into high-quality, natural audio.
- **Key Feature**: **Offline Support.** It is the primary voice engine when the app is in a "dead zone" (e.g., subway).

---

## 4. User Choice & Deployment Strategy

### A. First Launch Decision
At first launch, users are presented with a clear choice:
- **Enable Offline Guardian**: Triggers an on-demand download (~800MB) of local weights. This provides safety regardless of internet and immediate intervention for time-sensitive alerts.
- **Keep Cloud-Only**: No large download. All advice and TTS are generated via Cloud APIs.

### B. Dynamic Fallback Logic
The app's orchestrator makes real-time decisions:
1.  **If User Opted-In**:
    - **Normal**: Cloud AI for complex planning (Detailed/battery-saving).
    - **Weak Internet / Time-Sensitive Alert**: Local AI (`gemma-3-1b` + `Kokoro-82m`) for immediate safety.
2.  **If User Opted-Out**:
    - Always use Cloud AI. If the connection is lost, the app provides a standard "No Internet" notification and suggests seeking a safe haven until reconnected.

---

## 4. Performance & Reliability Constraints

| Metric | Target | Mitigation Strategy |
| :--- | :--- | :--- |
| **RAM Usage** | ~2.5 GB | Models are loaded only when a trip starts and purged when it ends. |
| **Latency** | < 800ms total | Parallel streaming: LLM token generation flows directly into the TTS buffer. |
| **Battery** | < 15%/hr | Offload to NPU (Neural Processing Unit) or GPU whenever possible. |
| **Reliability** | 100% Offline | Both models and their weights are bundled as app assets. |

## 5. Why the "Two-Model" Approach Matters
- **Emotional Calibration**: A standard "robot" voice can be a sensory trigger. The Local LLM crafts *gentle* sentences, and the high-quality TTS delivers them in a *calm* tone.
- **Privacy First**: Sensitive data about the user's immediate physical environment and stress levels never leave the device.
- **Immediate Intervention**: In a "Panic Mode" event, waiting for a cloud round-trip is not an option. The local assets ensure the "Secure Base" is always present, even in subway tunnels or dead zones.

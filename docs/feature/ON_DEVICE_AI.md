# Feature Specification: On-Device AI ("The Guardian")

## 1. Overview
"The Guardian" is the on-device intelligence layer of the Pocket Secure Base. It consists of a high-speed **Reflex Engine** and a **Vocabulary Asset Store** working in tandem to provide immediate, offline-capable sensory support during navigation.

For the high-level system flow, see the **Hybrid Intelligence Lifecycle** in [ARCHITECTURE.md](../ARCHITECTURE.md).

---

## 2. Core Components

### A. The Reflex Engine (Intelligence)
- **Model Choice**: **Tiny Classifier** (TFLite/CoreML).
- **Role**: A highly optimized neural network (~5-15MB) that acts as the "Context Switcher." It analyzes sensor data (GPS, Mic, Pulse) to trigger the correct social work intervention.
- **Latency**: Sub-10ms inference time for near-instantaneous response.

### B. Vocabulary Asset Store (The Voice)
- **Content**: A local library of high-fidelity audio assets voiced by human social workers.
- **Role**: Provides the "Safe Haven" verbal guidance and grounding exercises.
- **Key Feature**: **100% Deterministic.** Zero risk of AI hallucinations during a crisis.

### C. Local TTS (Dynamic Backup)
- **Model Choice**: **Kokoro-82m**.
- **Role**: Provides fallback for dynamic information (e.g., specific station names) not covered in the static asset store.


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

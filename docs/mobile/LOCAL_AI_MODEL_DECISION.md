# Decision: Local AI & Asset-Based Support

## 1. Overview
To fulfill the role of the **"Local Guardian"** (as defined in `ARCHITECTURE.md`), we require on-device components that provide immediate, low-latency feedback without relying on an internet connection. This document records the selection of a **Reflex Engine** and a **Vocabulary Asset Store** for this role.

## 2. Selected Components

| Component | Choice | Parameter Class / Size | Role |
| :--- | :--- | :--- | :--- |
| **Reflex Engine (Intelligence)** | **Tiny Classifier** | ~5-15 MB | Real-time classification of sensor data to trigger interventions. |
| **Asset Store (Voice)** | **Human-voiced Audio** | ~60-100 MB | High-fidelity, empathetic verbal guidance and grounding. |
| **Local TTS (Dynamic)** | **Kokoro-82m** | ~82 Million Parameters | Fallback for dynamic data (e.g., station names). |

---

## 3. Rationale for Selection

### A. Reflex Engine (Tiny Classifier)
- **Extreme Efficiency**: By using a small classification network instead of a 1B+ LLM, we reduce app size by 99% and battery drain to negligible levels.
- **Speed**: Provides sub-10ms inference, which is critical for a "Guardian" that must intervene instantly during a sensory surge.
- **Reliability**: Deterministic classification avoids the "hallucination" risks associated with generative models during a crisis.

### B. Vocabulary Asset Store
- **Human Empathy**: Real human recordings of social workers provide micro-nuances of co-regulation that AI voices cannot yet replicate.
- **Immediate Playback**: Triggering a pre-recorded file has zero processing latency compared to text generation.
- **Predictability**: Instructions are guaranteed to be medically and psychologically sound.

### C. Kokoro-82m (Fallback TTS)
- **Dynamic Support**: Necessary for reading out unpredictable transit data (e.g., specific delay times or platform numbers) that isn't in the static asset store.
- **Quality**: Produces natural-sounding Japanese pronunciation for navigation guidance.

---

## 4. Potential Challenges & Mitigations

| Challenge | Mitigation Strategy |
| :--- | :--- |
| **App Size** | The combined size of models and audio assets (~150MB) is now small enough to be **bundled with the app**, removing the need for on-demand downloads. |
| **Context Limitations** | The classifier is less flexible than an LLM. We mitigate this by using the **Strategic Planner (Cloud)** to pre-write and sync "Trip-Specific Scripts" before the user starts their journey. |
| **NPU/GPU Utilization** | Tiny models will be optimized for mobile NPUs (via TFLite/CoreML) to ensure zero impact on background tasks. |

---

## 5. Summary
The shift from a large Local LLM to a **Reflex-based Asset Retrieval** system ensures that the **Pocket Secure Base** remains highly performant, emotionally resonant, and 100% reliable in emergencies. The small footprint allows for full offline capability without compromising the user's device storage or battery.

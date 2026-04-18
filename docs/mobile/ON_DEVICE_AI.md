# Feature Specification: On-Device AI ("The Guardian")

## 1. Overview
"The Guardian" is the on-device intelligence layer of the DeepBreath. It consists of a high-speed **Reflex Engine** and a **Vocabulary Asset Store** working in tandem to provide immediate, offline-capable sensory support during navigation.

For the high-level system flow, see the **Hybrid Intelligence Lifecycle** in [ARCHITECTURE.md](../ARCHITECTURE.md).

---

## 2. Core Components

### A. The Reflex Engine (Intelligence)
- **Model Choice**: **Tiny Classifier** (TFLite/CoreML/ONNX).
- **Role**: A highly optimized, small-parameter neural network (~5-15MB) that acts as the "Context Switcher." It analyzes real-time sensor data (GPS, Mic, Pulse) to trigger the correct social work intervention.
- **Latency**: Sub-10ms inference time for near-instantaneous response.

### B. Vocabulary Asset Store (The Voice)
- **Content**: A local library of high-fidelity audio assets voiced by human social workers.
- **Role**: Provides the primary "Safe Haven" verbal guidance and grounding exercises.
- **Key Feature**: **100% Deterministic.** Zero risk of AI hallucinations or processing delays during a crisis.

---

## 3. Performance & Reliability Constraints

| Metric | Target | Mitigation Strategy |
| :--- | :--- | :--- |
| **App Size** | ~100-200 MB | Replacing large LLMs (Gemma) with a Tiny Classifier and optimized audio assets. |
| **Inference Latency** | < 10ms | Using a simple classification architecture instead of auto-regressive token generation. |
| **Battery Impact** | Negligible | Tiny models run efficiently on the device's NPU or low-power CPU cores. |
| **Reliability** | 100% Offline | All core assets and the classifier are bundled locally. |

---

## 4. Why the "Reflex + Asset" Approach Matters
- **Biological Safety**: A real human voice (Assets) has micro-nuances of empathy that synthetic AI voices cannot match, providing better co-regulation for users in distress.
- **Zero Hallucination**: During a subway hazard or sensory meltdown, the app must be 100% predictable. Pre-recorded assets ensure the instructions are always medically and psychologically sound.
- **Extreme Speed**: In a crisis, every millisecond counts. A classifier-based "Reflex" is hundreds of times faster than an LLM-based response.

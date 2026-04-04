# Decision: Local AI & TTS Models

## 1. Overview
To fulfill the role of the **"Local Guardian"** (as defined in `ARCHITECTURE.md`), we require on-device models that provide immediate, low-latency feedback without relying on an internet connection. This document records the selection of specific models for reasoning and text-to-speech (TTS).

## 2. Selected Models

| Component | Model | Size / Parameter Count | Role |
| :--- | :--- | :--- | :--- |
| **Local Primary Model** | `gemma-3-1b` | ~1 Billion Parameters | Real-time reasoning, sensory trigger detection, and "Guardian" instructions. |
| **Local TTS Model** | `Kokoro-82m` | ~82 Million Parameters | High-quality, low-latency verbal feedback for users. |

---

## 3. Rationale for Selection

### A. gemma-3-1b (The Guardian)
- **Efficiency**: Designed specifically for mobile and edge devices. At 1B parameters, it strikes a balance between being small enough for high-end mobile RAM while remaining capable of complex reasoning.
- **Speed**: Provides faster token generation than 7B or 13B models, which is critical for a "Guardian" that must intervene before a user reaches a high-stress area.
- **Multilingual Support**: Supports Japanese, which is essential for our target demographic and the Tokyo Metro integration.

### B. Kokoro-82m (The Voice)
- **Extreme Speed**: With only 82M parameters, it offers near-instantaneous inference on mobile CPUs/NPs.
- **Quality**: Despite its small size, it produces high-fidelity, natural-sounding speech compared to traditional rule-based TTS or larger neural models.
- **Japanese Performance**: Using the `Kokoro-J` weights ensures proper pronunciation of Japanese locations and transit instructions.

---

## 4. Potential Challenges & Mitigations

| Challenge | Mitigation Strategy |
| :--- | :--- |
| **App Bloat / Storage** | Models are **not bundled** with the initial download. They are delivered as **On-Demand Assets** (via Play Feature Delivery or iOS ODR) only after explicit user consent. |
| **Memory (RAM) Pressure** | Both models running simultaneously may be heavy. We will use **quantization** (e.g., 4-bit or 8-bit) and explore **MediaPipe LLM Inference API** or **ONNX Runtime** for memory-efficient execution. |
| **Flutter Integration** | There is no single "out-of-the-box" package for Gemma 3 + Kokoro. Implementation will likely require `onnxruntime_flutter` or native platform channels (Swift/Kotlin). |
| **Device Compatibility** | Performance may vary significantly on older devices. The app will include a "Fallback" mode using standard system TTS if `Kokoro` is too slow. |
| **Japanese Nuance** | Ensure the model weights are specifically fine-tuned or compatible with Japanese for accurate navigation guidance. |

---

## 5. Summary
The combination of `gemma-3-1b` and `Kokoro-82m` provides a cutting-edge, high-performance on-device AI stack. It ensures that the **Pocket Secure Base** remains functional and responsive even in subterranean transit environments where cloud connectivity is unreliable.

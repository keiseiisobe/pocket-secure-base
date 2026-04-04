# Strategy: Mitigating the "App Uninstall Problem"

## 1. The Challenge
Running high-performance models like `gemma-3-1b` and `Kokoro-82m` on-device can lead to three primary reasons for uninstalls:
1.  **Large App Size**: Bundling multiple GBs of model weights.
2.  **High Battery Drain**: Continuous NPU/CPU/GPU usage.
3.  **Device Overheating**: Sustained heavy computation causing thermal throttling and user discomfort.

## 2. Multi-Layered Mitigation Strategy

### A. "System-Native First" (Zero-Size AI)
Instead of always bundling our own models, we will leverage **OS-provided AI services** where available:
- **Android (AICore/Gemini Nano)**: Use Google's pre-installed Gemini Nano via the **Google AI Edge SDK**. This reduces the app size to nearly zero for the AI component and uses highly optimized system-level power management.
- **iOS (Apple Intelligence/CoreML)**: Use Apple's on-device foundation models (Writing Tools, etc.) or optimized CoreML models that leverage the Apple Neural Engine (ANE) with maximum "tokens-per-watt" efficiency.

### B. On-Demand Model Loading (Dynamic Assets)
To keep the initial download size small (e.g., under 50MB):
- **Deferred Download**: The app will not include model weights in the initial APK/IPA.
- **Triggered Download**: Weights for `gemma-3-1b` and `Kokoro` are downloaded only when the user first activates the "Guardian" feature or starts a trip.
- **Background Management**: Use Android **Play Feature Delivery** or iOS **On-Demand Resources** to manage these large assets.

### C. The "Small Trigger" Hybrid Architecture
To save battery during idle monitoring:
- **Phase 1 (The Sentry)**: Use an extremely small, low-power model (e.g., a <10MB DistilBERT or even simple rule-based logic) to monitor GPS and ambient noise.
- **Phase 2 (The Guardian)**: Only "wake up" the heavy `gemma-3-1b` and `Kokoro` models when the Sentry detects a potential stress event (e.g., noise > 80dB or proximity to a known crowded station).
- **Result**: Drastically reduces the "duty cycle" of the heavy models, preserving battery for 90% of the trip.

### D. Intelligent Hybrid Switching (Cloud vs. Edge)
The "Orchestrator" will decide where to run inference based on real-time device health:
- **Cloud Mode**: If the device has a strong 5G/Wi-Fi signal AND the battery is < 20% OR the device is already hot, offload reasoning to the Cloud API (OpenAI/Gemini Cloud) to save local resources.
- **Local Mode**: If the device is in a subway/dead zone OR the user is on a "Privacy-Sensitive" trip, force local execution.

### E. Model Quantization & Hardware Acceleration
- **4-bit/GGUF Quantization**: Mandatory for all local models to reduce RAM usage and increase inference speed.
- **Hardware Affinity**: Explicitly target the **NPU** (Neural Processing Unit) using `onnxruntime_flutter` or `MediaPipe`, which is significantly more power-efficient than using the general-purpose CPU.

---

## 3. Implementation Plan

| Action | Impact | Priority |
| :--- | :--- | :--- |
| **Implement System-Native Fallbacks** | Reduces size/battery for high-end users. | **High** |
| **Set up On-Demand Asset Loading** | Solves the "Big Download" uninstall problem. | **High** |
| **Develop "Sentry" Trigger Logic** | Extends battery life during long trips. | **Medium** |
| **Cloud/Local Orchestration** | Ensures safety even when local resources are low. | **Medium** |

---

## 4. Summary
By moving from a "Always-Local, Always-Heavy" model to an **"Adaptive, System-Native Hybrid"** model, we can provide the same safety (The Local Guardian) while ensuring the app remains lightweight, cool, and battery-friendly.

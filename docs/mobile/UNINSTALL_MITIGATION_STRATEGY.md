# Strategy: Mitigating the "App Uninstall Problem"

## 1. The Challenge
Historically, running high-performance models on-device led to uninstalls due to large app sizes (multiple GBs), high battery drain, and overheating. 

With the shift to the **Reflex Engine + Asset Store** architecture, we have significantly mitigated these risks, but proactive management remains essential.

## 2. Multi-Layered Mitigation Strategy

### A. Size Optimization (The Reflex Engine)
The transition from a 1GB+ Local LLM to a **150MB Reflex Engine + Asset Store** is our primary mitigation.
- **Bundled by Default**: The entire "Guardian" safety pack is now small enough to be included in the initial app download, ensuring user safety from Day 1 without complex on-demand downloads.
- **High-Fidelity Compression**: We use **Opus** for audio assets and **TFLite/CoreML quantization** for the classifier to maintain a small footprint as the vocabulary library grows.

### B. "System-Native First" (Zero-Size AI)
Where available, we leverage **OS-provided AI services** to further reduce local compute:
- **Android (AICore/Gemini Nano)**: For advanced dynamic reasoning if needed, leveraging Google's pre-installed models.
- **iOS (Apple Intelligence/CoreML)**: Utilizing the Apple Neural Engine (ANE) for maximum "tokens-per-watt" efficiency during classification.

### C. The "Small Trigger" Reflex Architecture
To save battery during idle monitoring:
- **Phase 1 (The Sentry)**: Extremely low-power rule-based logic monitors GPS and ambient noise.
- **Phase 2 (The Reflex)**: The **Tiny Classifier** (~10MB) only "wakes up" when the Sentry detects a potential stress event.
- **Result**: Drastically reduces the "duty cycle" of the NPU, preserving battery for 99% of the trip.

### D. Intelligent Hybrid Switching (Cloud vs. Edge)
The "Orchestrator" decides where to run inference based on real-time device health:
- **Cloud Mode**: If the device has a strong signal AND the battery is < 20% OR the device is already hot, offload reasoning to the **Situational Advisor (Cloud API)**.
- **Local Mode**: If the device is in a subway/dead zone OR the user is in a high-stress emergency, force **Local Reflex** execution for sub-10ms reliability.

### E. Model Quantization & Hardware Acceleration
- **4-bit Quantization**: Mandatory for all local components to minimize RAM footprint.
- **Hardware Affinity**: Explicitly target the **NPU** (Neural Processing Unit), which is significantly more power-efficient than the general-purpose CPU.

---

## 3. Implementation Plan

| Action | Impact | Priority |
| :--- | :--- | :--- |
| **Optimize Audio Compression** | Keeps bundled size under 200MB. | **High** |
| **NPU Model Optimization** | Minimizes battery drain during monitoring. | **High** |
| **Develop "Sentry" Trigger Logic** | Extends battery life during long trips. | **Medium** |
| **Cloud/Local Orchestration** | Ensures safety even when local resources are low. | **Medium** |

---

## 4. Summary
By moving to a **Lightweight Reflex-based system**, we have solved the "Big Download" problem. Our ongoing strategy focuses on **NPU-optimized monitoring** and **emotive asset management** to ensure the app remains cool, battery-friendly, and indispensable to the user.

# Strategy: Permission-Based AI Consent & Transparency

## 1. The "Consent-First" Approach
Instead of assuming every user wants on-device AI, we will implement an explicit **"Guarded Activation"** flow. This ensures users understand the trade-offs (storage, battery) in exchange for the benefits (offline safety, privacy).

## 2. The Three-Stage UX Flow

### A. Stage 1: The "Why" (Discovery)
When the user first explores the "Guardian" feature, we present a value-driven comparison:

| Feature | **Cloud-Only** (Default) | **Local Guardian** (Advanced) |
| :--- | :--- | :--- |
| **Safety** | Internet required. | **Works anywhere** (subways, dead zones). |
| **Privacy** | Data processed on servers. | **Data never leaves your phone.** |
| **Storage** | 0 MB used. | ~500 MB to 1.5 GB used. |
| **Battery** | Low usage. | Moderate to High usage. |

### B. Stage 2: The "Explicit Handshake" (Consent)
Before downloading any model weights, a system-style dialog will confirm the user's choice:
- **Title**: "Enable Offline Safety?"
- **Description**: "This will download a secure AI model to your device (~800MB). It allows your phone to provide safety alerts even without internet, but it will use more battery and storage."
- **Actions**: [Download & Enable] | [Keep Cloud-Only]

### C. Stage 3: Management & Agency
Users must feel they can "undo" the decision if their phone gets full or hot:
- **Storage Management**: A setting to "Clear AI Assets" which deletes the local weights but keeps the app.
- **Battery Optimization**: An "Auto-Pause" toggle that disables Local AI if the battery drops below 15%.
- **Thermal Awareness**: If the device overheats, show a notification: "Guardian is switching to Cloud mode to cool your device."

---

## 3. Benefits of This Approach
1.  **Trust**: By being honest about battery and storage, we reduce the "surprise" factor that leads to uninstalls.
2.  **Compliance**: Meets modern app store guidelines for "Generative AI Transparency."
3.  **Safety Integrity**: If a user *chooses* to enable it, they are more likely to keep it enabled during critical trips.
4.  **Device Compatibility**: Users on older phones with low storage can simply opt-out and use the Cloud-only version without being forced to uninstall the whole app.

## 5. Dual-Model Hybrid Operation (For Opt-In Users)
For users who enable the Local Guardian, the app operates in a "Smart Hybrid" mode:
- **Cloud AI (Primary)**: Used for initial route planning, detailed situational advice, and TTS when the internet connection is strong. This saves local battery and provides the most comprehensive reasoning.
- **Local AI (Immediate/Offline)**: Seamlessly takes over for **Advice and TTS** in two critical scenarios:
    1. **Weak/Lost Connection**: Ensuring safety in subway tunnels and dead zones.
    2. **Time-Sensitive Support**: When an immediate alert is needed (e.g., sudden loud noises), Local AI responds instantly without waiting for a cloud round-trip.

---

## 6. Summary
By treating **Local AI as a "Power User Feature"** for safety, we turn technical constraints into a user-centric choice. We explain it as an "Offline Safety Upgrade," giving the user the final say in how their device resources are used.

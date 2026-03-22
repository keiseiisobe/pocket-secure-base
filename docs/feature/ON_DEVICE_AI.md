# Feature Specification: On-Device AI ("The Guardian")

## 1. Overview
The On-Device AI, referred to as **"The Guardian,"** is a lightweight, locally-hosted model designed to provide immediate, low-latency sensory awareness and safety support. While the Cloud LLM handles complex route planning, The Guardian ensures the user is never left without guidance, even in areas with poor or no connectivity.

## 2. Core Services

### A. Real-Time Ambient Noise Monitoring
- **Function**: Continuously analyzes audio input from the device microphone (locally) to detect sudden decibel spikes or persistent high-volume environments.
- **Action**: Triggers immediate verbal alerts if the environment exceeds the user’s predefined sensory threshold (e.g., "The noise level here is rising. Would you like to put on noise-canceling headphones?").

### B. Zero-Latency Verbal Feedback
- **Function**: Provides situational awareness based on real-time GPS coordinates.
- **Benefit**: Unlike the Cloud LLM, which may take seconds to respond, The Guardian provides instant feedback as the user moves (e.g., "Turning left in 10 meters; stay toward the wall to avoid the crowd ahead").

### C. Offline-First Panic & Grounding Support
- **Grounding Exercises**: Manages the synchronization of haptic breathing patterns and audio grounding (playback of familiar voices) without requiring an internet connection.
- **Emergency Data Access**: Stores "One-Tap Home" coordinates and local "Safe Haven" locations for immediate retrieval during a network "dead zone."

### D. Geofence Interventions
- **Function**: Monitors the user's proximity to "High-Stress Zones" (identified during the planning phase) in the background.
- **Action**: Triggers haptic "nudges" or verbal reminders when approaching a stressful transition point, ensuring the user is prepared before they arrive.

## 3. Technical Implementation
- **Model Type**: Quantized TFLite (TensorFlow Lite) or Mediapipe models optimized for mobile NPU/GPU.
- **Privacy**: All audio analysis for noise levels and immediate GPS-to-speech processing happens strictly on-device. No raw audio or real-time movement data is streamed to the cloud for these "Guardian" functions.
- **Battery Optimization**: Utilizes low-power background processing to monitor environmental triggers without significant battery drain.

## 4. Why It Matters
For users with sensory processing sensitivities, a 5-second delay in AI reasoning is too long during a sudden sensory overload. The Guardian provides the **immediate safety net** required to maintain trust in the system, ensuring that the "Secure Base" is always available regardless of signal strength.

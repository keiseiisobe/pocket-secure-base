# Decision: Cloud AI Models for Strategic Planner, Situational Advisor, & TTS

## 1. Overview
DeepBreath utilizes a multi-layered Cloud AI architecture to balance complex strategic planning, real-time reactive support, and high-fidelity emotive feedback. This document records the selected models for these roles.

## 2. Selected Models

| Component | Model | Provider | Role |
| :--- | :--- | :--- | :--- |
| **Strategic Planner** | `gemini-2.0-flash` | Google | Agentic planning and complex tool calling (ODPT/Search). |
| **Situational Advisor** | `gemini-2.0-flash-lite` | Google | Real-time reactive monitoring and telemetry processing. |
| **Cloud TTS Service** | `eleven-flash-v2.5` | ElevenLabs | High-fidelity, emotive voice for verbal guidance and comfort. |

---

## 3. Rationale for Strategic Planner (Gemini 2.0 Flash)
- **Agentic Power**: Optimized for the "Reason -> Act -> Observe" loop required to query multiple transit and search APIs.
- **Native Tool Use**: Features industry-leading native function-calling reliability, essential for interacting with Tokyo Metro (ODPT) data.
- **Scalable Cost**: Flat pricing ($0.10/1M in, $0.40/1M out) ensures long-term sustainability.

---

## 4. Rationale for Situational Advisor (Gemini 2.0 Flash-Lite)
- **Ultra-Low Latency**: Optimized for the lowest "Time-to-First-Token," enabling a **< 1.5s end-to-end** target for reactive verbal guidance.
- **Efficiency**: 2.5x faster than standard Flash for short, reactive prompts, making it ideal for processing rapid telemetry (GPS, noise levels).

---

## 5. Rationale for Cloud TTS (ElevenLabs Flash v2.5)

### A. High Fidelity & Emotive Nuance
- **Human-Like Quality**: Provides the most natural-sounding "human" voice, which is critical for users who may find synthetic or robotic voices overstimulating.
- **Prosody Control**: Exceptional handling of emotional nuance, allowing the "Guardian" to sound calm and reassuring.

### B. Japanese Language Performance
- **Superior Pronunciation**: Outperforms competitors in handling complex Japanese station names and honorifics, essential for the primary Tokyo-based target market.

### C. Streaming Speed
- **Low Latency**: The "Flash" model offers ~75ms latency (Time-to-First-Audio), allowing for near-instantaneous streaming as the LLM generates text.

---

## 6. Comparison with Alternatives

| Model Class | Selected Model | Key Alternative | Trade-off |
| :--- | :--- | :--- | :--- |
| **Strategic LLM** | **Gemini 2.0 Flash** | Llama 3.3 70B | Gemini has superior native tool-use. |
| **Reactive LLM** | **Gemini 2.0 Flash-Lite** | DeepSeek-V3 | Flash-Lite has significantly lower latency. |
| **Cloud TTS** | **ElevenLabs Flash** | Hume AI (Octave 2) | Hume has better "Emotional IQ" but higher latency. |
| **Cloud TTS** | **ElevenLabs Flash** | Cartesia (Sonic-3) | Cartesia is faster (40ms) but has less emotive depth. |

---

## 7. Summary
By utilizing **Gemini 2.0 Flash/Lite** for intelligence and **ElevenLabs Flash** for voice, the DeepBreath achieves a "Gold Standard" architecture: intelligent enough to navigate the Tokyo Metro, fast enough to respond to immediate stress, and human enough to provide genuine comfort.

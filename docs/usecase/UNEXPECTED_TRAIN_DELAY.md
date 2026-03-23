# Use Case: Managing Station Transitions During a Delay

## 1. Situation
The user is at a major subway station during a trip. A mechanical failure causes a 20-minute delay, leading to rapidly increasing crowd density and noise levels on the platform—**the user is "stuck" in a high-stress transition point.**

## 2. System Intervention

### A. Real-Time Hub Monitoring
- **Cloud LLM**: Monitors the Tokyo Metro GTFS-RT (ODPT) feed and detects the delay.
- **On-Device AI ("The Guardian")**: Detects a 15dB spike in ambient noise via the microphone as the platform becomes crowded.

### B. Proactive Transition Advice
- **Immediate Action**: The app speaks via headphones: *"The platform is becoming crowded. Move to the quiet waiting room near Exit 4 while I find a better route."*
- **Station "Safe Space" Identification**: The app highlights a "Quiet Zone" within the station on the user's screen.

### C. The "Exit Strategy" (Dynamic Rerouting)
- **Alternative Path Search**: The LLM uses the **Google Search Tool** to check nearby bus routes and searches for a quieter walking alternative from the station's surface level.
- **Action**: Once the user is in the quiet spot, the app suggests: *"I've found a way to avoid the station entirely. We can walk for 10 minutes through a residential street to reach your destination."*

## 3. Outcome
By providing a clear "Exit Strategy" and identifying a quiet "Transition Point," the app prevents the user from being trapped in an overwhelming crowd and enables them to continue their journey autonomously.

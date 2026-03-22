# Use Case: Unexpected Train Delay

## 1. Situation
The user is at a major subway station. A sudden mechanical failure on their planned line causes a 20-minute delay, leading to rapidly increasing crowds and noise levels on the platform.

## 2. System Intervention

### A. Real-Time Detection
- **Cloud LLM**: Monitors the Tokyo Metro GTFS-RT (ODPT) feed and detects the delay immediately.
- **On-Device AI ("The Guardian")**: Detects a 15dB spike in ambient noise via the microphone as the platform becomes crowded.

### B. Proactive Guidance
- **Verbal Alert**: The app speaks via headphones: *"The Ginza line is currently delayed. The platform is becoming very crowded and loud. I recommend moving to the quiet waiting room near Exit 4 while I find a better route."*
- **Visual Update**: The UI shifts to a "Waiting Mode," highlighting the path to the nearest quiet zone.

### C. Dynamic Re-routing
- **LLM Reasoning**: The LLM uses the **Google Search Tool** to check if the delay affects nearby bus routes and searches for a quieter walking alternative.
- **Action**: Once the user is in a quiet spot, the app suggests: *"I've found a walking route that avoids the station entirely. It adds 10 minutes but stays in residential areas. Would you like to switch?"*

## 3. Outcome
The user avoids a sensory meltdown caused by the stationary crowd and noise, maintaining their autonomy by following a stress-free alternative route.

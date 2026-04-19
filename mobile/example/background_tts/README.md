# background_tts

Flutter example app that uses:

- `workmanager`
- `flutter_tts`

Behavior:

1. Tap **Start background TTS**.
2. Put the app in background.
3. A background worker tries to speak `こんにちは` every 10 seconds.

## Important note

This interval is **best effort** only. Mobile OS background execution rules may delay, batch, or skip executions depending on device state, battery optimization, and platform restrictions.

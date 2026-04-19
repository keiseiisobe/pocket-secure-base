/// Base URL for the Strategic Planner API (FastAPI).
///
/// Android emulator: `--dart-define=DEEPBREATH_API_BASE=http://10.0.2.2:8000`
/// iOS simulator / desktop: default `127.0.0.1` works.
const String kStrategicPlannerBaseUrl = String.fromEnvironment(
  'DEEPBREATH_API_BASE',
  defaultValue: 'http://127.0.0.1:8000',
);

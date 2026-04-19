import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/strategic_planner_api.dart';

final strategicPlannerApiProvider = Provider<StrategicPlannerApi>((ref) {
  final api = StrategicPlannerApi();
  ref.onDispose(api.close);
  return api;
});

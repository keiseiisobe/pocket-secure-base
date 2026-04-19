class RationaleItemView {
  const RationaleItemView({required this.title, required this.detail});

  final String title;
  final String detail;

  factory RationaleItemView.fromJson(Map<String, dynamic> json) {
    return RationaleItemView(
      title: json['title'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
    );
  }
}

class WaypointView {
  const WaypointView({required this.label, required this.address});

  final String label;
  final String address;

  factory WaypointView.fromJson(Map<String, dynamic> json) {
    return WaypointView(
      label: json['label'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }
}

class RoutePlanView {
  const RoutePlanView({
    required this.routeOverview,
    required this.rationaleItems,
    required this.waypoints,
    required this.travelMode,
    required this.navigationUrl,
    required this.toolMetadata,
  });

  final String routeOverview;
  final List<RationaleItemView> rationaleItems;
  final List<WaypointView> waypoints;
  final String travelMode;
  final String navigationUrl;
  final Map<String, dynamic> toolMetadata;

  factory RoutePlanView.fromJson(Map<String, dynamic> json) {
    final rationale = (json['rationale_items'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(RationaleItemView.fromJson)
        .toList();
    final wps = (json['waypoints'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(WaypointView.fromJson)
        .toList();
    final metaRaw = json['tool_metadata'];
    final meta = metaRaw is Map<String, dynamic>
        ? metaRaw
        : <String, dynamic>{};
    return RoutePlanView(
      routeOverview: json['route_overview'] as String? ?? '',
      rationaleItems: rationale,
      waypoints: wps,
      travelMode: json['travel_mode'] as String? ?? 'walking',
      navigationUrl: json['navigation_url'] as String? ?? '',
      toolMetadata: meta,
    );
  }
}

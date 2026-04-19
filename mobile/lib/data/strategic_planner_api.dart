import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/api_config.dart';
import '../domain/route_plan.dart';

/// HTTP client for Strategic Planner endpoints.
class StrategicPlannerApi {
  StrategicPlannerApi({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? kStrategicPlannerBaseUrl;

  final http.Client _client;
  final String _baseUrl;

  Uri get _planUri => Uri.parse('${_baseUrl.replaceAll(RegExp(r'/+$'), '')}/v1/plan');

  Future<RoutePlanView> requestPlan({
    required String origin,
    required String destination,
    required List<String> sensoryPreferences,
  }) async {
    final response = await _client.post(
      _planUri,
      headers: const {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(<String, dynamic>{
        'origin': origin,
        'destination': destination,
        'sensory_preferences': sensoryPreferences,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StrategicPlannerApiException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const StrategicPlannerApiException(statusCode: 500, body: 'Invalid JSON');
    }

    return RoutePlanView.fromJson(decoded);
  }

  void close() => _client.close();
}

class StrategicPlannerApiException implements Exception {
  const StrategicPlannerApiException({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;
  final String body;

  @override
  String toString() =>
      'StrategicPlannerApiException(statusCode: $statusCode, body: $body)';
}

import 'package:flutter_test/flutter_test.dart';

import 'package:url_launcher_example/main.dart';

void main() {
  testWidgets('shows waypoint limit and launch button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ExampleApp());

    expect(find.textContaining('Requested waypoints:'), findsOneWidget);
    expect(find.textContaining('Google Maps URL max:'), findsOneWidget);
    expect(find.textContaining('Open Google Maps'), findsOneWidget);
  });
}

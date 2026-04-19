import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const int googleMapsUrlMaxWaypoints = 9;

const String routeDestination = 'Ueno Park, Tokyo';

const List<String> requestedWaypointsToUenoPark = <String>[
  'Kanda Myojin Shrine, Tokyo',
  'Yushima Seido, Tokyo',
  'Yushima Tenjin Shrine, Tokyo',
  'Shinobazu Pond, Tokyo',
  'The Ueno Royal Museum, Tokyo',
  'The National Museum of Western Art, Tokyo',
  'National Museum of Nature and Science, Tokyo',
  'Tokyo National Museum, Tokyo',
  // 'Ueno Toshogu Shrine, Tokyo',
  // 'Tokyo University of the Arts, Ueno Campus, Tokyo',
];

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps Launcher Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MapsLauncherPage(),
    );
  }
}

class MapsLauncherPage extends StatelessWidget {
  const MapsLauncherPage({super.key});

  bool get isRequestedWaypointCountWithinGoogleMapsLimit =>
      requestedWaypointsToUenoPark.length <= googleMapsUrlMaxWaypoints;

  List<String> get launchableWaypoints =>
      requestedWaypointsToUenoPark.take(googleMapsUrlMaxWaypoints).toList();

  Uri _buildGoogleMapsDirectionUrl({required List<String> waypoints}) {
    return Uri.https('www.google.com', '/maps/dir/', <String, String>{
      'api': '1',
      'destination': routeDestination,
      'travelmode': 'walking',
      'dir_action': 'navigate',
      if (waypoints.isNotEmpty) 'waypoints': waypoints.join('|'),
    });
  }

  Future<void> _openGoogleMaps(BuildContext context) async {
    final Uri mapsWebUrl = _buildGoogleMapsDirectionUrl(
      waypoints: launchableWaypoints,
    );

    final bool launched = await launchUrl(
      mapsWebUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw Exception('Could not launch Google Maps.');
    }

    if (!context.mounted) {
      return;
    }

    if (!isRequestedWaypointCountWithinGoogleMapsLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Google Maps URL supports up to $googleMapsUrlMaxWaypoints waypoints. '
            'Requested: ${requestedWaypointsToUenoPark.length}. '
            'Launching with first ${launchableWaypoints.length}.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int requestedCount = requestedWaypointsToUenoPark.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Maps Launcher')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Requested waypoints: $requestedCount'),
            Text('Google Maps URL max: $googleMapsUrlMaxWaypoints'),
            Text(
              'Within limit: ${isRequestedWaypointCountWithinGoogleMapsLimit ? 'YES' : 'NO'}',
              style: TextStyle(
                color: isRequestedWaypointCountWithinGoogleMapsLimit
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _openGoogleMaps(context),
              child: Text(
                'Open Google Maps (${launchableWaypoints.length}/$requestedCount waypoints)',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

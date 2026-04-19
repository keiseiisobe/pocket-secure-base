import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:workmanager/workmanager.dart';

const String kBackgroundTtsTaskName = 'background_tts_task';
const String kBackgroundTtsUniqueWorkName = 'background_tts_unique_work';
const Duration kBackgroundSpeakInterval = Duration(seconds: 10);
const String kSpeechText = 'こんにちは';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((String task, Map<String, dynamic>? inputData) async {
    debugPrint("executing background tasks");

    final FlutterTts tts = FlutterTts();
    await tts.setLanguage('ja-JP');
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.45);
    await tts.speak(kSpeechText);

    return Future<bool>.value(true);
  });
}

Future<void> _scheduleBackgroundSpeak() {
  debugPrint("registering oneOffTask");
  return Workmanager().registerOneOffTask(
    kBackgroundTtsUniqueWorkName,
    kBackgroundTtsTaskName,
    initialDelay: kBackgroundSpeakInterval,
    existingWorkPolicy: ExistingWorkPolicy.replace,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(
    callbackDispatcher,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("building MyApp widget");
    return MaterialApp(
      title: 'Background TTS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const BackgroundTtsHomePage(),
    );
  }
}

class BackgroundTtsHomePage extends StatefulWidget {
  const BackgroundTtsHomePage({super.key});

  @override
  State<BackgroundTtsHomePage> createState() => _BackgroundTtsHomePageState();
}

class _BackgroundTtsHomePageState extends State<BackgroundTtsHomePage> {
  String _status = 'Not started';

  Future<void> _startBackgroundTts() async {
    final FlutterTts tts = FlutterTts();
    await tts.setLanguage('ja-JP');
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.45);
    await tts.speak(kSpeechText);

    await _scheduleBackgroundSpeak();
    if (!mounted) {
      return;
    }
    setState(() {
      _status = 'Scheduled every 10 seconds (best effort)';
    });
  }

  Future<void> _stopBackgroundTts() async {
    await Workmanager().cancelByUniqueName(kBackgroundTtsUniqueWorkName);
    if (!mounted) {
      return;
    }
    setState(() {
      _status = 'Stopped';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Background TTS (Workmanager)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Tap start, then send app to background.\nThe worker speaks "こんにちは" repeatedly.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Status: $_status',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startBackgroundTts,
                child: const Text('Start background TTS'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _stopBackgroundTts,
                child: const Text('Stop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

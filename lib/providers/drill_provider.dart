import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quakecare/screens/safe_zone_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DrillProvider with ChangeNotifier {
  FlutterTts flutterTts = FlutterTts();
  bool _isDrillStarted = false;
  int _currentStep = 0;
  Timer? _timer;
  List<String> _steps = [];
  final DateTime _selectedDateTime = DateTime.now();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // TextEditingController for managing input field
  final TextEditingController _controller = TextEditingController();

  bool get isDrillStarted => _isDrillStarted;
  int get currentStep => _currentStep;
  List<String> get steps => _steps;
  DateTime get selectedDateTime => _selectedDateTime;
  TextEditingController get controller => _controller;

  DrillProvider() {
    flutterTts.setLanguage("tr-TR");
    tz.initializeTimeZones();
    _loadSteps();
  }

  Future<void> _loadSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _steps = prefs.getStringList('steps') ?? [];
    notifyListeners();
  }

  Future<void> _speakStep(int step) async {
    if (step < _steps.length) {
      await flutterTts.speak(_steps[step]);
    }
  }

  void _startSpeakingSteps() {
    debugPrint("Starting to speak steps...");
    _timer?.cancel(); // Önceki timer'ı iptal et
    _speakStep(_currentStep);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentStep < _steps.length) {
        debugPrint("Speaking step $_currentStep");
        _speakStep(_currentStep);
      } else {
        debugPrint("All steps completed, cancelling timer.");
        timer.cancel();
      }
    });
  }

  void startDrill() {
    if (_steps.isEmpty) return;
    _isDrillStarted = true;
    if (hasListeners) {
      notifyListeners();
    }
    _startSpeakingSteps();
  }

  void completeStep(BuildContext context) {
    if (_currentStep < _steps.length - 1) {
      _currentStep++;
      if (hasListeners) {
        notifyListeners();
      }
      _timer?.cancel();
      _startSpeakingSteps();
      _speakStep(_currentStep);
    } else {
      _timer?.cancel();
      flutterTts.stop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SafeZoneScreen()),
      );
    }
  }

  void addStep(String step) {
    _steps.add(step);
    _saveSteps();
    if (hasListeners) {
      notifyListeners();
    }
  }

  void removeStep(int index) {
    _steps.removeAt(index);
    _saveSteps();
    if (hasListeners) {
      notifyListeners();
    }
  }

  void moveStepUp(int index) {
    if (index > 0) {
      final item = _steps.removeAt(index);
      _steps.insert(index - 1, item);
      _saveSteps();
      if (hasListeners) {
        notifyListeners();
      }
    }
  }

  void moveStepDown(int index) {
    if (index < _steps.length - 1) {
      final item = _steps.removeAt(index);
      _steps.insert(index + 1, item);
      _saveSteps();
      if (hasListeners) {
        notifyListeners();
      }
    }
  }

  Future<void> _saveSteps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('steps', _steps);
  }

  Future<void> scheduleDrillNotification() async {
    if (_selectedDateTime.isBefore(DateTime.now())) {
      // Show an error message if time is invalid
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Tatbikat Zamanı Geldi!',
      'Tatbikatınızı başlatmak için uygulamayı açın.',
      tz.TZDateTime.from(_selectedDateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'quakecare_channel',
          'QuakeCare Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    flutterTts.stop();
    _controller.dispose(); // Controller'ı dispose etmeyi unutmayın
    super.dispose();
  }
}

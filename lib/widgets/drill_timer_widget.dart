import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
// ignore: library_prefixes
import 'package:timezone/data/latest.dart' as tzData;
import 'package:intl/intl.dart'; // Tarih formatı için
import 'package:shared_preferences/shared_preferences.dart';

class DrillTimerWidget extends StatefulWidget {
  const DrillTimerWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DrillTimerWidgetState createState() => _DrillTimerWidgetState();
}

class _DrillTimerWidgetState extends State<DrillTimerWidget> {
  late DateTime _selectedDateTime;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final String _message = ''; // Mesaj alanı
  late Timer _timer; // Zamanlayıcı

  @override
  void initState() {
    super.initState();
    tzData.initializeTimeZones();
    _initializeNotifications();
    _loadDrillTime(); // Tatbikat zamanını yükle
  }

  // Bildirim servisini başlatma
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Tatbikat zamanını SharedPreferences'tan yükle
  Future<void> _loadDrillTime() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTime = prefs.getString('drill_time');

    if (storedTime != null) {
      setState(() {
        _selectedDateTime = DateTime.parse(storedTime); // Zamanı geri yükle
      });
    } else {
      setState(() {
        _selectedDateTime = DateTime.now(); // Varsayılan olarak şu anki zaman
      });
    }
  }

  // Tatbikat zamanını SharedPreferences'a kaydet
  Future<void> _saveDrillTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('drill_time',
        _selectedDateTime.toIso8601String()); // ISO formatında kaydet
  }

  // Tatbikat zamanını ayarlama
  Future<void> _scheduleDrillNotification() async {
    if (_selectedDateTime.isBefore(DateTime.now())) {
      _showDialog('Hata', 'Geçerli bir zaman seçin.');
      return;
    }

    // Tatbikat zamanı geldiğinde başlatmak için bildirim zamanlanması
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

    _saveDrillTime(); // Tatbikat zamanını kaydet
    _showDialog('Başarılı', 'Tatbikat zamanınız başarıyla ayarlandı!');
    _startDrillAutomatically();
  }

  // Tatbikat zamanı geldiğinde bildirim gönderme
  void showUrgentNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'quakecare_urgent_channel',
      'QuakeCare Urgent Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'urgent',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      1,
      title,
      body,
      platformChannelSpecifics,
      payload: 'rehberlik', // Rehberlik ekranına yönlendirme için payload
    );
  }

  // Tatbikatı otomatik başlatma
  Future<void> _startDrillAutomatically() async {
    final currentTime = DateTime.now();
    if (_selectedDateTime.isBefore(currentTime)) {
      showUrgentNotification('Tatbikat Zamanı Geldi!',
          'Tatbikatınızı başlatmak için uygulamayı açın.');
// Tatbikat başlat
    } else {
      // Zamanı gelene kadar kontrol et
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (DateTime.now().isAfter(_selectedDateTime)) {
          showUrgentNotification('Tatbikat Zamanı Geldi!',
              'Tatbikatınızı başlatmak için uygulamayı açın.');
          //widget.onDrillStart();
          _timer.cancel(); // Timer'ı durdur
        }
      });
    }
  }

  // Zaman seçme fonksiyonu
  Future<void> _selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  // Dialog gösterme fonksiyonu
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialogu kapat
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _selectDateTime,
          icon: const Icon(Icons.calendar_today),
          label: const Text("Tatbikat Zamanı Seç"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            backgroundColor: Colors.green[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Seçilen zaman: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime)}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _scheduleDrillNotification,
          icon: const Icon(Icons.notifications),
          label: const Text("Tatbikatı Zamanla"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            backgroundColor: Colors.orangeAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        if (_message.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            _message,
            style: TextStyle(
              color: _message == 'Tatbikat zamanınız başarıyla ayarlandı!'
                  ? Colors.green
                  : Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}

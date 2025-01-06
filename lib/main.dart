import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:quakecare/providers/drill_provider.dart';
import 'package:quakecare/screens/home_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onNotificationResponse,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => DrillProvider(),
      child: const QuakeCareApp(),
    ),
  );
}

/// Bildirime tıklanınca çağrılır
void onNotificationResponse(NotificationResponse notificationResponse) {
  if (notificationResponse.payload != null) {
    debugPrint('Bildirime tıklanıldı: ${notificationResponse.payload}');
  }
}

class QuakeCareApp extends StatelessWidget {
  const QuakeCareApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Navigator key ekleniyor
      debugShowCheckedModeBanner: false,
      title: 'QuakeCare',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blueAccent,
        buttonTheme: const ButtonThemeData(buttonColor: Colors.blueAccent),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueAccent,
      ),
      themeMode: ThemeMode.system, // Sistem ayarlarına göre tema
      home: const HomeScreen(),
    );
  }
}

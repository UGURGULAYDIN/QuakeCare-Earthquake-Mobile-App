import 'dart:async';
import 'dart:convert'; // JSON parse işlemleri için
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart'; // AssetLoader için
import 'package:quakecare/services/location_service.dart';
import 'package:quakecare/services/notification_service.dart';

class SafeZoneCard extends StatefulWidget {
  const SafeZoneCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SafeZoneCardState createState() => _SafeZoneCardState();
}

class _SafeZoneCardState extends State<SafeZoneCard> {
  final LocationService locationService = LocationService();
  final NotificationService notificationService = NotificationService();

  String locationMessage = "Konum alınıyor...";
  String nearestSafeZone = "En yakın güvenli alan belirleniyor...";
  String directionMessage = "Yönlendirme bekleniyor...";
  bool isLoading = true; // Yüklenme durumu
  List<Map<String, dynamic>> safeZones = []; // JSON'dan yüklenecek

  @override
  void initState() {
    super.initState();
    notificationService.initialize(_onNotificationTap);
    _loadSafeZones(); // JSON'dan güvenli alanları yükle
  }

  Future<void> _loadSafeZones() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/safe_zones.json'); // JSON oku
      List<dynamic> jsonData = json.decode(jsonString);

      setState(() {
        safeZones =
            jsonData.map((item) => Map<String, dynamic>.from(item)).toList();
      });

      _fetchLocation(); // Konumu al ve güvenli alanları bul
    } catch (e) {
      setState(() {
        locationMessage = "Güvenli alanlar yüklenirken bir hata oluştu: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _fetchLocation() async {
    try {
      Position position = await locationService.getCurrentPosition();
      setState(() {
        locationMessage =
            "Mevcut Konum:\nEnlem: ${position.latitude}, Boylam: ${position.longitude}";
        isLoading = false;
      });
      _findNearestSafeZone(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        locationMessage = "Konum alınamadı: $e";
        isLoading = false;
      });
    }
  }

  void _findNearestSafeZone(double userLatitude, double userLongitude) {
    double shortestDistance = double.infinity;
    String nearestZone = "Belirlenemedi";
    Map<String, dynamic>? closestSafeZone;

    for (var zone in safeZones) {
      double distance = locationService.calculateDistance(
        userLatitude,
        userLongitude,
        zone["latitude"],
        zone["longitude"],
      );

      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestZone = zone["name"];
        closestSafeZone = zone;
      }
    }

    if (closestSafeZone != null) {
      String direction = _generateDirection(userLatitude, userLongitude,
          closestSafeZone["latitude"], closestSafeZone["longitude"]);
      setState(() {
        nearestSafeZone =
            "En yakın güvenli alan: $nearestZone (${(shortestDistance / 1000).toStringAsFixed(2)} km)";
        directionMessage = direction;
      });

      if (shortestDistance > 1000) {
        notificationService.showNotification(
          "Uyarı!",
          "Güvenli alandan 1 kilometre uzaklaştınız!",
        );
      }
    }
  }

  String _generateDirection(
      double userLat, double userLng, double zoneLat, double zoneLng) {
    double deltaLat = zoneLat - userLat;
    double deltaLng = zoneLng - userLng;

    if (deltaLat.abs() > deltaLng.abs()) {
      return deltaLat > 0
          ? "Kuzeye doğru ilerleyin."
          : "Güneye doğru ilerleyin.";
    } else {
      return deltaLng > 0
          ? "Doğuya doğru ilerleyin."
          : "Batıya doğru ilerleyin.";
    }
  }

  void _onNotificationTap(String? payload) {
    if (payload != null) {
      debugPrint("Bildirim Tıklamasıyla gelen veri: $payload");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.blue),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              locationMessage,
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.security, color: Colors.green),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              nearestSafeZone,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.directions, color: Colors.orange),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              directionMessage,
                              style: const TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.italic),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert'; // JSON parse işlemleri için
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart'; // AssetLoader için
import 'package:flutter_map/flutter_map.dart'; // Harita için
import 'package:latlong2/latlong.dart'; // Harita koordinatları için
import 'package:quakecare/services/location_service.dart';
import 'package:quakecare/services/notification_service.dart';
import 'package:quakecare/widgets/safe_zone_widget.dart'; // Kart widget'ını içeri aktar

class SafeZoneScreen extends StatefulWidget {
  const SafeZoneScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SafeZoneScreenState createState() => _SafeZoneScreenState();
}

class _SafeZoneScreenState extends State<SafeZoneScreen> {
  final LocationService locationService = LocationService();
  final NotificationService notificationService = NotificationService();

  String locationMessage = "Konum alınıyor...";
  String nearestSafeZone = "En yakın güvenli alan belirleniyor...";
  String directionMessage = "Yönlendirme bekleniyor...";
  bool isLoading = true; // Yüklenme durumu
  List<Map<String, dynamic>> safeZones = []; // JSON'dan yüklenecek
  LatLng? currentLocation; // Kullanıcının mevcut konumu
  MapController mapController = MapController(); // Harita kontrolcüsü

  @override
  void initState() {
    super.initState();

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
        currentLocation = LatLng(position.latitude, position.longitude);
        locationMessage =
            "Mevcut Konum:\nEnlem: ${position.latitude}, Boylam: ${position.longitude}";
        isLoading = false;

        // Haritayı mevcut konuma taşı
        mapController.move(currentLocation!, 14.0);
      });
    } catch (e) {
      setState(() {
        locationMessage = "Konum alınamadı: $e";
        isLoading = false;
      });
    }
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];

    if (currentLocation != null) {
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: currentLocation!,
          builder: (ctx) => const Icon(
            Icons.my_location,
            color: Colors.blue,
            size: 35.0,
          ),
        ),
      );
    }

    LatLng? nearestSafeZoneLocation; // En yakın güvenli alanın koordinatları

    for (var zone in safeZones) {
      // Güvenli alanın koordinatlarını al
      LatLng zoneLocation = LatLng(zone["latitude"], zone["longitude"]);

      // Eğer en yakın güvenli alan bulunmadıysa, bu güvenli alanı en yakın olarak belirle
      nearestSafeZoneLocation ??= zoneLocation;

      // Mesafeyi hesapla (enlem ve boylam farkına dayalı basit mesafe hesaplaması)
      double distance = locationService.calculateDistance(
        currentLocation!.latitude,
        currentLocation!.longitude,
        zone["latitude"],
        zone["longitude"],
      );

      // Eğer şu anki güvenli alan, daha önce bulunan en yakın alandan daha yakınsa, onu en yakın olarak belirle
      if (distance <
          locationService.calculateDistance(
              currentLocation!.latitude,
              currentLocation!.longitude,
              nearestSafeZoneLocation.latitude,
              nearestSafeZoneLocation.longitude)) {
        nearestSafeZoneLocation = zoneLocation;
      }

      // Eğer bu güvenli alan en yakınsa, marker rengini turuncu yap, aksi takdirde yeşil
      Color markerColor = zoneLocation == nearestSafeZoneLocation
          ? Colors.green
          : Colors.blueGrey;

      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: zoneLocation,
          builder: (ctx) => Icon(
            Icons.place,
            color: markerColor, // Marker rengini burada ayarlıyoruz
            size: 35.0,
          ),
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Güvenli Alan Önerisi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    center: currentLocation ??
                        LatLng(37.7749, -122.4194), // Default center
                    zoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(markers: _buildMarkers()),
                  ],
                ),
                const Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: SafeZoneCard(), // SafeZoneCard widget'ı alt kısımda
                ),
              ],
            ),
    );
  }
}

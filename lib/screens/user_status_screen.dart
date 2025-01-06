import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quakecare/services/location_service.dart';

class UserStatusScreen extends StatefulWidget {
  const UserStatusScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserStatusScreenState createState() => _UserStatusScreenState();
}

class _UserStatusScreenState extends State<UserStatusScreen> {
  final LocationService locationService = LocationService();
  LatLng? currentLocation;
  MapController mapController = MapController();
  bool isLoading = true;
  String locationMessage = "Konum alınıyor...";
  List<Map<String, dynamic>> users = []; // Kullanıcı verilerini tutan liste
  String userStatus = 'Güvendeyim'; // Varsayılan statü

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Kullanıcı verilerini yükle
  }

  Future<void> _loadUserData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/users.json');
      List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        users =
            jsonData.map((item) => Map<String, dynamic>.from(item)).toList();
      });
      _fetchLocation();
    } catch (e) {
      setState(() {
        locationMessage = "Kullanıcı verileri yüklenirken hata oluştu: $e";
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
        mapController.move(currentLocation!, 14.0);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Kullanıcıların harita üzerindeki markerlarını oluştur
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

    // Kullanıcıların markerlarını oluştur
    for (var user in users) {
      LatLng userLocation = LatLng(user["latitude"], user["longitude"]);
      Color markerColor = _getMarkerColor(user["status"]);

      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: userLocation,
          builder: (ctx) => Icon(
            Icons.person_pin,
            color: markerColor,
            size: 35.0,
          ),
        ),
      );
    }

    return markers;
  }

  // Statüye göre marker rengini belirle
  Color _getMarkerColor(String status) {
    switch (status) {
      case 'Acil Yardım Gerek!':
        return Colors.red;
      case 'Yardıma İhtiyacım Var':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  // Statü değiştirildiğinde JSON dosyasını güncelle
  void _updateUserStatus(String status) {
    setState(() {
      userStatus = status;
    });

    // Kullanıcının statüsünü JSON'da güncelle
    int userIndex = users.indexWhere((user) =>
        user['latitude'] == currentLocation?.latitude &&
        user['longitude'] == currentLocation?.longitude);
    if (userIndex != -1) {
      setState(() {
        users[userIndex]['status'] = userStatus;
      });
    }

    // JSON dosyasını kaydetme işlemi burada yapılabilir (örneğin, bir API'ye göndererek)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kullanıcı Durumu",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan[900],
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
                    center: currentLocation ?? LatLng(37.7749, -122.4194),
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
                Positioned(
                  bottom: 20, // Sayfanın alt kısmına yerleştir
                  left: 20,
                  right: 20,
                  child: Card(
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
                                        const Icon(Icons.location_on,
                                            color: Colors.blue),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            locationMessage,
                                            style:
                                                const TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownButton<String>(
                                      value: userStatus,
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          _updateUserStatus(newValue);
                                        }
                                      },
                                      items: <String>[
                                        'Güvendeyim',
                                        'Yardıma İhtiyacım Var',
                                        'Acil Yardım Gerek!'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

import 'package:geolocator/geolocator.dart';

class LocationService {
  // Konum servisi açık mı kontrolü
  Future<bool> isLocationServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Konum servisiniz kapalı. Lütfen açın.");
    }
    return serviceEnabled;
  }

  // Konum iznini kontrol etme ve talep etme
  Future<LocationPermission> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Konum izni vermelisiniz.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          "Konum izni kalıcı olarak reddedildi. Ayarlardan izin vermelisiniz.");
    }

    return permission;
  }

  // Kullanıcının mevcut konumunu almak
  Future<Position> getCurrentPosition() async {
    try {
      await isLocationServiceEnabled(); // Konum servisini kontrol et
      await checkAndRequestPermission(); // İzinleri kontrol et
      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      ); // Konum al
      return position;
    } catch (e) {
      throw Exception("Konum alınamadı: $e");
    }
  }

  // İki koordinat arasındaki mesafeyi hesapla (metre cinsinden)
  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }
}

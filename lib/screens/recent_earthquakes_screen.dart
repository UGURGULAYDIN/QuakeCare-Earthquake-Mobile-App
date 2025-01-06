import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecentEarthquakesScreen extends StatefulWidget {
  const RecentEarthquakesScreen({super.key});

  @override
  State<RecentEarthquakesScreen> createState() =>
      _RecentEarthquakesScreenState();
}

class _RecentEarthquakesScreenState extends State<RecentEarthquakesScreen> {
  List<dynamic> earthquakes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEarthquakeData();
  }

  Future<void> fetchEarthquakeData() async {
    // USGS API URL - Türkiye koordinatlarına yakın büyük depremler
    const apiUrl =
        "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2024-01-01&endtime=2025-12-31&minmagnitude=4&maxlatitude=42.1&minlatitude=36.0&maxlongitude=45.0&minlongitude=26.0";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          earthquakes = data["features"];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load earthquake data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Türkiye'deki Son Depremler",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : earthquakes.isEmpty
              ? const Center(child: Text("Son deprem verisi bulunamadı."))
              : ListView.builder(
                  itemCount: earthquakes.length,
                  itemBuilder: (context, index) {
                    final earthquake = earthquakes[index];
                    final properties = earthquake["properties"];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Text(
                            properties["mag"].toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title:
                            Text(properties["place"] ?? "Bilinmeyen Lokasyon"),
                        subtitle: Text(
                          "Tarih: ${DateTime.fromMillisecondsSinceEpoch(properties["time"]).toLocal()}",
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title:
                                  Text(properties["place"] ?? "Deprem Detayı"),
                              content: Text(
                                "Büyüklük: ${properties["mag"]}\n"
                                "Tarih: ${DateTime.fromMillisecondsSinceEpoch(properties["time"]).toLocal()}\n"
                                "Derinlik: ${earthquake["geometry"]["coordinates"][2]} km",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Tamam"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

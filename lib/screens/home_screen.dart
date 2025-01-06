import 'package:flutter/material.dart';
import 'package:quakecare/screens/drill_screen.dart';
import 'package:quakecare/screens/contact_screen.dart';
import 'package:quakecare/screens/recent_earthquakes_screen.dart';
import 'package:quakecare/screens/safe_zone_screen.dart';
import 'package:quakecare/screens/emergency_kit_screen.dart';
import 'package:quakecare/screens/user_status_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueGrey[900] ?? Colors.blueGrey,
                Colors.blueGrey,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'QuakeCare',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hakkında'),
                  content: const Text(
                      'QuakeCare, deprem anında ve sonrasında güvende kalmanıza yardımcı olur.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Tamam'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Spacer to create gap between AppBar and buttons
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 30, // Increase spacing between buttons
                children: [
                  _buildButton(
                    context,
                    title: 'Tatbikat Rehberi',
                    icon: Icons.school,
                    color: Colors.blueGrey[600]!,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DrillScreen()),
                    ),
                  ),
                  _buildButton(
                    context,
                    title: 'Güvenli Alan Önerisi',
                    icon: Icons.location_on,
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SafeZoneScreen()),
                    ),
                  ),
                  _buildButton(
                    context,
                    title: 'Acil Durum Rehberi',
                    icon: Icons.phone_in_talk,
                    color: Colors.red,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactScreen()),
                    ),
                  ),
                  _buildButton(
                    context,
                    title: 'Deprem Çantası',
                    icon: Icons.backpack,
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmergencyKitScreen()),
                    ),
                  ),
                  _buildButton(
                    context,
                    title: 'Son Depremler',
                    icon: Icons.warning,
                    color: Colors.deepOrange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const RecentEarthquakesScreen()),
                    ),
                  ),
                  _buildButton(
                    context,
                    title: 'Kullanıcı Durumu',
                    icon: Icons.account_circle, // Yeni ikon
                    color: Colors.cyan[900] ?? Colors.cyan, // Renk değiştirildi
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserStatusScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.cyanAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lightbulb, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Güvende kalmak için her zaman hazırlıklı olun!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

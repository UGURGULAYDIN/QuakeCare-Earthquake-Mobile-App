import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quakecare/providers/drill_provider.dart'; // DrillProvider'ı import edin

class GuideScreen extends StatefulWidget {
  final List<String> steps;
  final VoidCallback onComplete;
  final VoidCallback? onDrillStart;

  const GuideScreen({
    super.key,
    required this.steps,
    required this.onDrillStart,
    required this.onComplete,
  });

  @override
  // ignore: library_private_types_in_public_api
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    widget.onDrillStart!(); // Tatbikat başladığında çağrılıyor
  }

  void _completeStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() {
        _currentStep++;
        widget.onComplete(); // Adım tamamlandığında ekranı yenile
      });
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DrillProvider(), // DrillProvider'ı burada sağlayın
      child: Consumer<DrillProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Tatbikat Rehberi"),
              backgroundColor: Colors.blueGrey[600],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.steps[
                          _currentStep], // Adım metni burada gösteriliyor
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _completeStep, // Adım tamamlandığında çağrılır
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[400],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        _currentStep < widget.steps.length - 1
                            ? "Adımı Tamamla"
                            : "Tatbikatı Bitir",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

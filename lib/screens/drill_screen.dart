import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quakecare/providers/drill_provider.dart';
import 'package:quakecare/widgets/drill_timer_widget.dart';
import 'package:quakecare/screens/guide_screen.dart'; // GuideScreen'i import et

class DrillScreen extends StatelessWidget {
  final VoidCallback? onDrillStart;

  const DrillScreen({super.key, this.onDrillStart});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DrillProvider(),
      child: Consumer<DrillProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Tatbikat Rehberi",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.blueGrey[600],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GuideScreen(
                            steps: provider.steps,
                            onDrillStart: provider.startDrill,
                            onComplete: () => provider.completeStep(context),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Tatbikat Başlat"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const DrillTimerWidget(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: provider.controller,
                          decoration: const InputDecoration(
                            labelText: "Yeni Adım Ekle",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          provider.addStep(provider.controller.text);
                          provider.controller.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[600],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Ekle"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.steps.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          child: ListTile(
                            leading: CircleAvatar(child: Text("${index + 1}")),
                            title: Text(
                              provider.steps[index],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_upward,
                                      color: Colors.cyan[400]),
                                  onPressed: () => provider.moveStepUp(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_downward,
                                      color: Colors.grey[400]),
                                  onPressed: () => provider.moveStepDown(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => provider.removeStep(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

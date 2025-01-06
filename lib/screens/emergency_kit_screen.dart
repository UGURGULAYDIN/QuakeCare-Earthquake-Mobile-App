import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyKitScreen extends StatefulWidget {
  const EmergencyKitScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmergencyKitScreenState createState() => _EmergencyKitScreenState();
}

class _EmergencyKitScreenState extends State<EmergencyKitScreen> {
  List<String> items = [
    "Su (kişi başı günlük 1 litre)",
    "Yiyecek (konserve, kuruyemiş)",
    "Fener ve yedek piller",
    "İlk yardım malzemeleri",
    "Çok amaçlı çakı",
    "Battaniye veya uyku tulumu",
    "Önemli evrakların kopyaları",
    "Nakit para",
    "Telefon şarj cihazı ve powerbank",
  ];

  List<bool> isChecked = [];
  final TextEditingController _itemController = TextEditingController();
  int? _editingIndex; // Düzenleme için indeks

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  Future<void> _loadChecklist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      items = prefs.getStringList('items') ?? items;
      // isChecked listesinde her öğe için false değerini başlat
      isChecked = List<bool>.from(
        List.generate(
            items.length, (index) => prefs.getBool('isChecked$index') ?? false),
      );
    });
  }

  Future<void> _saveChecklist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('items', items);
    for (int i = 0; i < items.length; i++) {
      prefs.setBool('isChecked$i', isChecked[i]);
    }
  }

  void _addItem(String newItem) {
    setState(() {
      items.add(newItem);
      isChecked.add(false); // Yeni öğe işaretlenmemiş olarak başlatılır
    });
    _saveChecklist();
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
      isChecked.removeAt(index);
    });
    _saveChecklist();
  }

  void _editItem(int index) {
    _itemController.text = items[index];
    setState(() {
      _editingIndex = index;
    });
  }

  void _updateItem() {
    if (_itemController.text.isNotEmpty && _editingIndex != null) {
      setState(() {
        items[_editingIndex!] = _itemController.text;
        _editingIndex = null; // Düzenlemeyi tamamladıktan sonra sıfırlama
      });
      _saveChecklist();
      _itemController.clear();
    }
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Deprem Çantası",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Checkbox(
                        value: isChecked[index],
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked[index] = value ?? false;
                          });
                          _saveChecklist();
                        },
                      ),
                      title: Text(
                        items[index],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _editItem(index); // Düzenleme butonuna tıklanınca
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteItem(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _itemController,
                      decoration: InputDecoration(
                        labelText: _editingIndex == null
                            ? "Yeni Madde Ekle"
                            : "Maddeyi Düzenle", // Başlık değişir
                        hintText: "Örneğin: Yedek pil",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_itemController.text.isNotEmpty) {
                        if (_editingIndex == null) {
                          _addItem(_itemController.text); // Yeni madde ekle
                        } else {
                          _updateItem(); // Var olan maddeyi güncelle
                        }
                        _itemController.clear();
                      }
                    },
                    child: Text(
                      _editingIndex == null
                          ? "Ekle"
                          : "Güncelle", // Buton metni değişir
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

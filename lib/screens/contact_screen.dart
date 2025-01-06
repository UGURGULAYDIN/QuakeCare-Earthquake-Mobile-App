import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // Panoya kopyalama için

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Map<String, String>> contacts = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts(); // Verileri yükle
  }

  // Rehberi SharedPreferences'tan yükle
  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedContacts = prefs.getStringList('contacts');
    if (savedContacts != null) {
      setState(() {
        contacts = savedContacts.map((contact) {
          final split = contact.split(',');
          return {'name': split[0], 'number': split[1]};
        }).toList();
      });
    }
  }

  // Telefonu aramak için fonksiyon
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    // ignore: deprecated_member_use
    if (await canLaunch(launchUri.toString())) {
      // ignore: deprecated_member_use
      await launch(launchUri.toString());
    } else {
      throw 'Telefon numarasına arama yapılamadı: $phoneNumber';
    }
  }

  // Numara panoya kopyalama fonksiyonu
  Future<void> _copyToClipboard(String phoneNumber) async {
    await Clipboard.setData(ClipboardData(text: phoneNumber));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Numara panoya kopyalandı!")),
    );
  }

  // Kişi silme fonksiyonu
  Future<void> _removeContact(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    contacts.removeAt(index);
    List<String> updatedContacts = contacts.map((contact) {
      return '${contact['name']},${contact['number']}';
    }).toList();
    await prefs.setStringList('contacts', updatedContacts);
    setState(() {});
  }

  // Yeni Kişi Ekleme fonksiyonu
  Future<void> _addContact() async {
    if (_nameController.text.isNotEmpty && _numberController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> contactsList = prefs.getStringList('contacts') ?? [];
      contactsList.add('${_nameController.text},${_numberController.text}');
      await prefs.setStringList('contacts', contactsList);

      // SetState ile listeyi güncelle
      setState(() {
        contacts.add({
          'name': _nameController.text,
          'number': _numberController.text,
        });
      });

      _nameController.clear();
      _numberController.clear();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm bilgileri girin!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Acil Durum Rehberi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red, // Başlık rengi
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Yeni Kişi Ekle'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Kişinin Adı',
                          ),
                        ),
                        TextField(
                          controller: _numberController,
                          decoration: const InputDecoration(
                            labelText: 'Telefon Numarası',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: _addContact,
                        child: const Text('Ekle'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Vazgeç'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Yeni Kişi Ekle"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                      contacts[index]['name']!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      contacts[index]['number']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.phone, color: Colors.green),
                          onPressed: () {
                            _makePhoneCall(contacts[index]['number']!);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.blue),
                          onPressed: () {
                            _copyToClipboard(contacts[index]['number']!);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _removeContact(index);
                          },
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
    );
  }
}

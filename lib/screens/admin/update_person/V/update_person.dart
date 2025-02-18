import 'dart:io';
import 'package:crm_k/core/models/personel_model/personel_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

//db bağlanacak
class PersonnelUpdateScreen extends StatefulWidget {
  final PersonnelModel personnel;
  const PersonnelUpdateScreen({super.key, required this.personnel});

  @override
  _PersonnelUpdateScreenState createState() => _PersonnelUpdateScreenState();
}

class _PersonnelUpdateScreenState extends State<PersonnelUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.personnel.name);
    _emailController = TextEditingController(text: widget.personnel.email);
    _phoneController = TextEditingController(text: widget.personnel.phone);
  }

  Future<void> _updatePersonnel() async {
    try {
      // **1️⃣ JSON dosyasını oku**
      final String response =
          await rootBundle.loadString('assets/personnel.json');
      List<dynamic> personnelList = json.decode(response);

      // **2️⃣ Güncellenecek personeli bul**
      int index =
          personnelList.indexWhere((p) => p["id"] == widget.personnel.id);
      if (index == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("❌ Güncelleme başarısız: Personel bulunamadı!")),
        );
        return;
      }

      // **3️⃣ Yeni verileri güncelle**
      personnelList[index] = {
        "id": widget.personnel.id,
        "name": _nameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "role": widget.personnel.role, // **Rol değiştirilmiyor!**
      };

      // **4️⃣ Güncellenmiş JSON'u dosyaya yaz**
      final String updatedJson = jsonEncode(personnelList);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/personnel.json');
      await file.writeAsString(updatedJson);

      // **5️⃣ Başarı mesajı ve sayfayı kapatma**
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Personel başarıyla güncellendi!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Güncelleme başarısız: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personel Güncelle")),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_nameController, "Ad Soyad", Icons.person),
                _buildTextField(_emailController, "E-Posta", Icons.email,
                    enabled: false),
                _buildTextField(_phoneController, "Telefon", Icons.phone),
                const SizedBox(height: 20),

                // 📌 Güncelle Butonu
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updatePersonnel();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text("Güncelle"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
        enabled: enabled,
        validator: (value) => value!.isEmpty ? "Bu alan boş bırakılamaz" : null,
      ),
    );
  }
}

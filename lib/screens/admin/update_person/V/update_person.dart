import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserUpdateScreen extends StatefulWidget {
  final User user;
  const UserUpdateScreen({super.key, required this.user});

  @override
  _UserUpdateScreenState createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _investmentAmountController;
  String _phoneStatus = "Onayladı"; // Varsayılan değer

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _investmentAmountController =
        TextEditingController(text: widget.user.investmentAmount.toString());
    _phoneStatus = widget.user.phoneStatus ?? 'false';
  }

  Future<void> _updateUser() async {
    final String apiUrl =
        "http://localhost:8080/update-user/${widget.user.email}";

    final Map<String, dynamic> updatedData = {
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "investment_amount":
          double.tryParse(_investmentAmountController.text) ?? 0,
      "phone_status": _phoneStatus,
    };

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Kullanıcı başarıyla güncellendi!")),
      );
      Navigator.pop(context); // Güncelleme sonrası geri dön
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Güncelleme başarısız: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kullanıcı Güncelle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(_nameController, "Ad Soyad", Icons.person),
                  _buildTextField(_emailController, "E-Posta", Icons.email,
                      enabled: false),
                  _buildTextField(_phoneController, "Telefon", Icons.phone),
                  _buildTextField(_investmentAmountController,
                      "Yatırım Miktarı", Icons.attach_money),

                  // 📌 Telefon Durumu (Dropdown)
                  DropdownButtonFormField<String>(
                    value: _phoneStatus,
                    items: ["Cevapsız", "Yanlış No", "Meşgul", "Onayladı"]
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _phoneStatus = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Telefon Durumu",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_callback),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 📌 Güncelle Butonu
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateUser();
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
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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

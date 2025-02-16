import 'package:crm_k/core/models/personel_model/personel_model.dart';
import 'package:crm_k/screens/admin/add_person/VM/admin_add_person_viewmodule.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonnelAddScreen extends StatefulWidget {
  const PersonnelAddScreen({super.key});

  @override
  _PersonnelAddScreenState createState() => _PersonnelAddScreenState();
}

class _PersonnelAddScreenState extends State<PersonnelAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = "personel"; // Varsayılan rol
  final bool _isAdmin = true; // 📌 Şimdilik herkes admin olarak kabul ediliyor

  @override
  Widget build(BuildContext context) {
    final personnelVM =
        Provider.of<PersonnelAddViewModel>(context, listen: false);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              width: MediaQuery.of(context).size.width > 600
                  ? 500
                  : double.infinity, // 📌 Responsive tasarım
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(_nameController, "Ad Soyad", Icons.person),
                    _buildTextField(_emailController, "E-posta", Icons.email),
                    _buildTextField(_phoneController, "Telefon", Icons.phone),
                    _buildTextField(_passwordController, "Şifre", Icons.lock,
                        obscureText: true),
                    const SizedBox(height: 10),

                    // 📌 Rol Seçimi (Dropdown)
                    DropdownButtonFormField<String>(
                      value: _role,
                      items: ["personel", "admin"]
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _role = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Rol",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.admin_panel_settings),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 📌 Gelişmiş Buton Tasarımı
                    ElevatedButton(
                      onPressed: _isAdmin
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                personnelVM.addPersonnel(PersonnelModel(
                                  id: DateTime.now().millisecondsSinceEpoch,
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  phone: _phoneController.text,
                                  role: _role,
                                  assignedCustomers: [],
                                  totalInvestment: 0,
                                  createdAt: DateTime.now(),
                                ));

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "✅ Personel başarıyla eklendi!")),
                                );

                                _formKey.currentState!.reset();
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAdmin ? Colors.blue : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 16),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Personel Ekle"),
                    ),

                    if (!_isAdmin)
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "❌ Sadece adminler personel ekleyebilir!",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 📌 Gelişmiş `TextField` Widget'ı (İkonlu ve Şık)
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscureText = false,
    String type = "",
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon: Icon(icon),
        ),
        obscureText: obscureText,
        validator: (value) {
          value!.isEmpty ? "Bu alan boş bırakılamaz" : null;
          return null;
        },
      ),
    );
  }
}

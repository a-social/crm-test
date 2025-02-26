import 'package:crm_k/core/service/admin_service.dart';
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

  void _submitForm(PersonnelAddViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      bool success = await viewModel.addPersonnel(
        PersonnelModel(
          id: DateTime.now().millisecondsSinceEpoch, // Geçici ID
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phone: _phoneController.text,
          role: _role,
          assignedCustomers: [],
          totalInvestment: 0,
          createdAt: DateTime.now(),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? "✅ Personel başarıyla eklendi!"
              : viewModel.errorMessage ?? "Bilinmeyen bir hata oluştu."),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        _formKey.currentState!.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PersonnelAddViewModel(
        token: Provider.of<AdminProvider>(context, listen: false).token ?? '',
      ),
      child: Consumer<PersonnelAddViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Personel Ekle")),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    width: MediaQuery.of(context).size.width > 600
                        ? 500
                        : double.infinity, // Responsive tasarım
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTextField(
                              _nameController, "Ad Soyad", Icons.person),
                          _buildTextField(
                              _emailController, "E-posta", Icons.email),
                          _buildTextField(
                              _phoneController, "Telefon", Icons.phone),
                          _buildTextField(
                              _passwordController, "Şifre", Icons.lock,
                              obscureText: true),
                          const SizedBox(height: 10),

                          // 📌 Rol Seçimi (Dropdown)
                          DropdownButtonFormField<String>(
                            value: _role,
                            items: ["personel"]
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
                            onPressed: viewModel.isLoading
                                ? null
                                : () => _submitForm(viewModel),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: viewModel.isLoading
                                  ? Colors.grey
                                  : Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 16),
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: viewModel.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text("Personel Ekle"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 📌 Gelişmiş `TextField` Widget'ı (İkonlu ve Şık)
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscureText = false,
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
          if (value == null || value.isEmpty) {
            return "$label boş bırakılamaz";
          }
          return null;
        },
      ),
    );
  }
}

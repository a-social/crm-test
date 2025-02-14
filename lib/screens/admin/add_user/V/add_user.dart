import 'package:crm_k/screens/admin/add_user/VM/add_user_vm.dart';
import 'package:crm_k/screens/admin/addbase/V/addmodelview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAddScreen extends StatelessWidget {
  const UserAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userAddVM = Provider.of<UserAddViewModel>(context);

    return AddBasicModel(
      widget: Form(
        key: userAddVM.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(userAddVM.nameController, "Ad Soyad", Icons.person),
            _buildTextField(userAddVM.emailController, "E-posta", Icons.email),
            _buildTextField(userAddVM.phoneController, "Telefon", Icons.phone),
            const SizedBox(height: 10),

            // 📌 Kime Bağlı? (Dropdown)
            DropdownButtonFormField<String>(
              value: userAddVM.assignedTo,
              items:
                  ["", "zeynep@gmail.com", "ahmet@gmail.com", "admin@gmail.com"]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.isEmpty ? "Kimseye Bağlı Değil" : e),
                          ))
                      .toList(),
              onChanged: userAddVM.setAssignedTo,
              decoration: const InputDecoration(
                labelText: "Kime Bağlı?",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.supervisor_account),
              ),
            ),

            const SizedBox(height: 20),

            // 📌 Şık Buton Tasarımı
            userAddVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () => userAddVM.addUser(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 16),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Kullanıcı Ekle"),
                  ),
          ],
        ),
      ),
    );
  }

  /// 📌 Şık `TextField` Widget'ı (İkonlu ve Kenarları Yuvarlatılmış)
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
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
        validator: (value) => value!.isEmpty ? "Bu alan boş bırakılamaz" : null,
      ),
    );
  }
}

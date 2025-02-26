import 'package:crm_k/core/service/admin_service.dart';
import 'package:crm_k/core/models/company_model/manager/company_manager.dart';
import 'package:crm_k/screens/admin/update_company/VM/update_company_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCompanyView extends StatelessWidget {
  const EditCompanyView({super.key});

  void showEditDialog(
      BuildContext context, EditCompanyViewModel viewModel, int index) {
    final company = viewModel.companies[index];

    final TextEditingController nameController =
        TextEditingController(text: company.name);
    final TextEditingController emailController =
        TextEditingController(text: company.email);
    final TextEditingController addressController =
        TextEditingController(text: company.address);
    final TextEditingController phoneController =
        TextEditingController(text: company.phone);
    final TextEditingController websiteController =
        TextEditingController(text: company.website);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Şirketi Düzenle"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(nameController, "Firma Adı", Icons.business),
              const SizedBox(height: 10),
              _buildTextField(emailController, "E-Posta", Icons.email),
              const SizedBox(height: 10),
              _buildTextField(addressController, "Adres", Icons.location_on),
              const SizedBox(height: 10),
              _buildTextField(phoneController, "Telefon", Icons.phone),
              const SizedBox(height: 10),
              _buildTextField(websiteController, "Web Sitesi", Icons.web),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () async {
              print(company.id);
              bool success = await viewModel.updateCompany(
                id: company.id,
                name: nameController.text,
                email: emailController.text,
                address: addressController.text,
                phone: phoneController.text,
                website: websiteController.text,
              );

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? "Firma başarıyla güncellendi!"
                      : "Güncelleme başarısız."),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );
            },
            child: const Text("Kaydet"),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditCompanyViewModel(
        CompanyManager(
            token:
                Provider.of<AdminProvider>(context, listen: false).token ?? ''),
      )..fetchCompanies(),
      child: Scaffold(
        body: Consumer<EditCompanyViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.companies.isEmpty) {
              return const Center(child: Text("Şirket bulunamadı."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: viewModel.companies.length,
              itemBuilder: (context, index) {
                final company = viewModel.companies[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(company.name ?? "Bilinmeyen"),
                    subtitle: Text(company.email ?? "Email yok"),
                    trailing: const Icon(Icons.edit, color: Colors.blue),
                    onTap: () {
                      showEditDialog(context, viewModel, index);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

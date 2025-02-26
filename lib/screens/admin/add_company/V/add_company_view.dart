import 'package:crm_k/core/service/admin_service.dart';
import 'package:crm_k/screens/admin/add_company/VM/add_company_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({super.key});

  @override
  _AddCompanyState createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  void _showConfirmationDialog(AddCompanyViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Onaylıyor musunuz?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("İsim: ${_nameController.text}"),
            Text("E-posta: ${_emailController.text}"),
            Text("Adres: ${_addressController.text}"),
            Text("Telefon: ${_phoneController.text}"),
            Text("Web sitesi: ${_websiteController.text}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _submitForm(viewModel);
            },
            child: const Text("Onayla"),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm(AddCompanyViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      bool success = await viewModel.addCompany(
        name: _nameController.text,
        email: _emailController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        website: _websiteController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Firma başarıyla eklendi!")),
        );
        _nameController.clear();
        _emailController.clear();
        _addressController.clear();
        _phoneController.clear();
        _websiteController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(viewModel.errorMessage ?? "Bilinmeyen bir hata oluştu."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdminProvider? provider =
        Provider.of<AdminProvider?>(context, listen: false);
    if (provider == null || provider.token == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return ChangeNotifierProvider(
        create: (_) => AddCompanyViewModel(token: provider.token ?? 'null'),
        child: Consumer<AddCompanyViewModel>(
          builder: (context, viewModel, child) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(child: SizedBox.shrink()),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: SizedBox.shrink()),
                            Card(
                              child: Container(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    _buildTextField(_nameController,
                                        "Firma Adı", Icons.business),
                                    const SizedBox(height: 10),
                                    _buildTextField(_emailController, "E-Posta",
                                        Icons.email),
                                    const SizedBox(height: 10),
                                    _buildTextField(_addressController, "Adres",
                                        Icons.location_on),
                                    const SizedBox(height: 10),
                                    _buildTextField(_phoneController, "Telefon",
                                        Icons.phone),
                                    const SizedBox(height: 10),
                                    _buildTextField(_websiteController,
                                        "Web Sitesi", Icons.web),
                                    const SizedBox(height: 20),
                                    viewModel.isLoading
                                        ? const CircularProgressIndicator()
                                        : ElevatedButton(
                                            onPressed: () =>
                                                _showConfirmationDialog(
                                                    viewModel),
                                            child: const Text("Firma Ekle"),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(child: SizedBox.shrink()),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox.shrink()),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label boş olamaz";
        }
        return null;
      },
    );
  }
}

import 'package:crm_k/core/service/admin_service.dart';
import 'package:crm_k/core/models/company_model/manager/company_manager.dart';
import 'package:crm_k/screens/admin/delete_company/VM/delete_company_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteCompanyView extends StatelessWidget {
  const DeleteCompanyView({super.key});

  void showDeleteDialog(
      BuildContext mainContext, String companyId, String companyName) {
    showDialog(
      context: mainContext,
      builder: (context) => AlertDialog(
        title: const Text("Şirketi Sil"),
        content:
            Text("$companyName adlı şirketi silmek istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Dialog'u kapat
              bool success = await mainContext
                  .read<DeleteCompanyViewModel>()
                  .deleteCompany(companyId);

              if (!success) {
                final errorMessage =
                    mainContext.read<DeleteCompanyViewModel>().errorMessage ??
                        "Bilinmeyen bir hata oluştu.";
                ScaffoldMessenger.of(mainContext).showSnackBar(
                  SnackBar(
                      content: Text(errorMessage), backgroundColor: Colors.red),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Evet, Sil"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeleteCompanyViewModel(
        CompanyManager(
            token:
                Provider.of<AdminProvider>(context, listen: false).token ?? ''),
      )..fetchCompanies(),
      child: Builder(
        // Builder ekleyerek context'i güncelliyoruz
        builder: (context) {
          return Scaffold(
            body: Consumer<DeleteCompanyViewModel>(
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
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              company.name ?? "Bilinmeyen",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text("📧 ${company.email ?? 'Yok'}"),
                            Text("📍 ${company.address ?? 'Yok'}"),
                            Text("📞 ${company.phone ?? 'Yok'}"),
                            Text(
                              "🌐 ${company.website ?? 'Yok'}",
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDeleteDialog(context, company.id,
                                      company.name ?? "Bu şirket");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Sil"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

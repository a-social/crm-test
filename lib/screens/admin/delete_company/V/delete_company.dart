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
              Navigator.pop(context); // Onay ekranını kapat
              showDeletingDialog(mainContext); // ✅ Silme işlemi ekranı aç
              bool success = await mainContext
                  .read<DeleteCompanyViewModel>()
                  .deleteCompany(companyId);

              Navigator.pop(mainContext); // ✅ Silme ekranını kapat

              if (!success) {
                ScaffoldMessenger.of(mainContext).showSnackBar(
                  const SnackBar(
                      content: Text("Şirket silinirken hata oluştu."),
                      backgroundColor: Colors.red),
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

  void showDeletingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ✅ Kullanıcı ekranı kapatamaz!
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // ✅ Geri tuşu çalışmaz
        child: AlertDialog(
          title: const Text("Silme İşlemi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Şirket siliniyor..."),
            ],
          ),
        ),
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
      child: Consumer<DeleteCompanyViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            body: viewModel.companies.isEmpty
                ? const Center(child: Text("Şirket bulunamadı."))
                : ListView.builder(
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
                  ),
          );
        },
      ),
    );
  }
}

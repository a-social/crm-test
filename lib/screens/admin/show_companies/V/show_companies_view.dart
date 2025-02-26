import 'package:crm_k/core/service/admin_service.dart';
import 'package:crm_k/core/models/company_model/manager/company_manager.dart';
import 'package:crm_k/screens/admin/show_companies/VM/show_companies_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanyListView extends StatelessWidget {
  const CompanyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CompanyListViewModel(
        CompanyManager(
            token:
                Provider.of<AdminProvider>(context, listen: false).token ?? ''),
      )..fetchCompanies(),
      child: Scaffold(
        body: Consumer<CompanyListViewModel>(
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
                          company.name ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "📧 ${company.email}",
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "📍 ${company.address}",
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "📞 ${company.phone}",
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "🌐 ${company.website}",
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "🕒 ${company.createdAt?.toLocal()}",
                            style: const TextStyle(color: Colors.grey),
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
      ),
    );
  }
}

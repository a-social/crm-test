import 'package:crm_k/core/models/company_model/company_model.dart';
import 'package:crm_k/core/models/company_model/manager/company_manager.dart';
import 'package:flutter/material.dart';

class DeleteCompanyViewModel extends ChangeNotifier {
  final CompanyManager _companyManager;
  List<CompanyModel> companies = [];
  bool isLoading = false;
  bool isDeleting = false; // ✅ Silme işlemi aktif mi?

  DeleteCompanyViewModel(this._companyManager);

  Future<void> fetchCompanies() async {
    isLoading = true;
    notifyListeners();

    final response = await _companyManager.getCompanies();
    companies = response.map((e) => CompanyModel.fromJson(e)).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<bool> deleteCompany(String id) async {
    isDeleting = true; // ✅ Silme işlemi başladı
    notifyListeners();

    bool success = await _companyManager.deleteCompany(id);

    if (success) {
      companies.removeWhere((company) => company.id == id);
    }

    isDeleting = false; // ✅ Silme işlemi bitti
    notifyListeners();
    return success;
  }
}

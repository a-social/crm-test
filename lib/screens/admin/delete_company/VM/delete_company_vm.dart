import 'package:crm_k/core/models/company_model/company_model.dart';
import 'package:crm_k/core/models/company_model/manager/company_manager.dart';
import 'package:flutter/material.dart';

class DeleteCompanyViewModel extends ChangeNotifier {
  final CompanyManager _companyManager;
  List<CompanyModel> companies = [];
  bool isLoading = false;
  bool isDeleting = false;
  String? errorMessage; // ❌ Yeni hata mesajı değişkeni

  DeleteCompanyViewModel(this._companyManager);

  Future<void> fetchCompanies() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _companyManager.getCompanies();
      companies = response.map((e) => CompanyModel.fromJson(e)).toList();
    } catch (e) {
      errorMessage =
          "Şirketleri çekerken hata oluştu. Lütfen internet bağlantınızı kontrol edin.";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> deleteCompany(String id) async {
    isDeleting = true;
    errorMessage = null;
    notifyListeners();

    try {
      bool success = await _companyManager.deleteCompany(id);
      if (success) {
        companies.removeWhere((company) => company.id == id);
        notifyListeners();
        return true;
      } else {
        errorMessage = "Şirket silinemedi. Lütfen tekrar deneyin.";
      }
    } catch (e) {
      errorMessage = "Bağlantı hatası! Sunucuya ulaşılamıyor.";
    }

    isDeleting = false;
    notifyListeners();
    return false;
  }
}

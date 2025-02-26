import 'package:crm_k/core/models/company_model/manager/company_manager.dart';
import 'package:flutter/material.dart';

class AddCompanyViewModel extends ChangeNotifier {
  final CompanyManager _companyManager;
  bool isLoading = false;
  String? errorMessage; // ✅ Hata mesajı eklendi

  AddCompanyViewModel({required String token})
      : _companyManager = CompanyManager(token: token);

  Future<bool> addCompany({
    required String name,
    required String email,
    required String address,
    required String phone,
    required String website,
  }) async {
    isLoading = true;
    errorMessage = null; // Hata mesajını sıfırla
    notifyListeners();

    try {
      bool success = await _companyManager.addCompany(
        name: name,
        email: email,
        address: address,
        phone: phone,
        website: website,
      );

      if (!success) {
        errorMessage =
            "Firma eklenirken hata oluştu. API eksik veri kaydediyor olabilir.";
      }

      isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      isLoading = false;
      errorMessage = "Bağlantı hatası! Sunucuya ulaşılamıyor.";
      notifyListeners();
      return false;
    }
  }
}

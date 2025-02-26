import 'package:crm_k/core/models/company_model/manager/company_manager.dart';
import 'package:flutter/material.dart';

class AddCompanyViewModel extends ChangeNotifier {
  final CompanyManager _companyManager;
  bool isLoading = false;

  AddCompanyViewModel({required String token})
      : _companyManager = CompanyManager(token: token);

  Future<bool> addCompany({
    required String name,
    required String email,
    required String address,
    required String phone,
    required String website,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      bool success = await _companyManager.addCompany(
        name: name,
        email: email,
        address: address,
        phone: phone,
        website: website,
      );

      isLoading = false;
      notifyListeners();

      return success;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('Firma eklenirken hata oluştu: $e');
      return false;
    }
  }
}

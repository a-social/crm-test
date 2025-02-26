import 'package:crm_k/core/models/company_model/company_model.dart';
import 'package:crm_k/core/models/company_model/manager/company_manager.dart';
import 'package:flutter/material.dart';

class EditCompanyViewModel extends ChangeNotifier {
  final CompanyManager _companyManager;
  List<CompanyModel> companies = [];
  bool isLoading = false;
  bool isUpdating = false;

  EditCompanyViewModel(this._companyManager);

  Future<void> fetchCompanies() async {
    isLoading = true;
    notifyListeners();

    final response = await _companyManager.getCompanies();
    companies = response.map((e) => CompanyModel.fromJson(e)).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<bool> updateCompany({
    required String id,
    required String name,
    required String email,
    required String address,
    required String phone,
    required String website,
  }) async {
    isUpdating = true;
    notifyListeners();

    bool success = await _companyManager.updateCompany(
      id: id,
      name: name,
      email: email,
      address: address,
      phone: phone,
      website: website,
    );

    isUpdating = false;
    notifyListeners();

    if (success) {
      int index = companies.indexWhere((c) => c.id == id);
      if (index != -1) {
        companies[index] = CompanyModel(
          id: id,
          name: name,
          email: email,
          address: address,
          phone: phone,
          website: website,
          createdAt: companies[index].createdAt,
        );
      }
      notifyListeners();
    }

    return success;
  }
}

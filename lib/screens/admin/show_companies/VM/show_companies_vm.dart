import 'package:crm_k/core/models/company_model/company_model.dart';
import 'package:crm_k/core/models/company_model/manager/company_manager.dart';
import 'package:flutter/material.dart';

class CompanyListViewModel extends ChangeNotifier {
  final CompanyManager _companyManager;
  List<CompanyModel> companies = [];
  bool isLoading = false;

  CompanyListViewModel(this._companyManager);

  Future<void> fetchCompanies() async {
    isLoading = true;
    notifyListeners();

    final response = await _companyManager.getCompanies();
    companies = response.map((e) => CompanyModel.fromJson(e)).toList();

    isLoading = false;
    notifyListeners();
  }
}

import 'package:crm_k/core/models/personel_model/manager/personel_manager.dart';
import 'package:crm_k/core/models/personel_model/personel_model.dart';
import 'package:flutter/material.dart';

class PersonnelAddViewModel extends ChangeNotifier {
  final PersonelMainManager _personnelManager;
  bool isLoading = false;
  String? errorMessage;

  PersonnelAddViewModel({required String token})
      : _personnelManager = PersonelMainManager(token: token);

  Future<bool> addPersonnel(PersonnelModel personnel) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      bool success = await _personnelManager.addPersonnel(
        name: personnel.name,
        email: personnel.email,
        password: personnel.password,
        phone: personnel.phone,
        role: personnel.role,
      );

      if (!success) {
        errorMessage = "Personel eklenemedi, lütfen tekrar deneyin.";
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

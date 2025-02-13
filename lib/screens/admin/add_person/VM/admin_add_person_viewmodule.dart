import 'package:crm_k/core/models/admin_model/manager/admin_manager.dart';
import 'package:crm_k/core/models/personel_model/personel_model.dart';
import 'package:flutter/material.dart';

class PersonnelAddViewModel extends ChangeNotifier {
  final AdminManager _adminManager = AdminManager(); // Admin kontrolü
  final List<PersonnelModel> _personnelList = []; // Eklenen personelleri tutar

  bool isAdmin = true; // 📌 Şimdilik her kullanıcı admin olarak simüle ediliyor

  // Yeni personel ekleme
  void addPersonnel(PersonnelModel personnel) {
    if (!isAdmin) {
      print("❌ Yetkisiz işlem! Sadece adminler personel ekleyebilir.");
      return;
    }
    _personnelList.add(personnel);
    print("✅ Personel eklendi: ${personnel.name}");
    notifyListeners();
  }

  // Admin kontrolü (ileride genişletilebilir)
  bool checkIfAdmin(String email) {
    return _adminManager.adminExists(email);
  }

  List<PersonnelModel> get allPersonnel => List.unmodifiable(_personnelList);
}

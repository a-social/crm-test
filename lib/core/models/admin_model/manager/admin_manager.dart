import 'dart:convert';
import 'dart:math';

import 'package:crm_k/core/models/admin_model/admin_model.dart';
import 'package:flutter/services.dart';

class AdminManager {
  final List<AdminModel> _adminList = [];

  void addAdmin(AdminModel admin) {
    _adminList.add(admin);
    // print('Admin added: ${admin.name}');
  }

  void removeAdmin(String email) {
    _adminList.removeWhere((admin) => admin.email == email);
    // print('Admin with email $email removed.');
  }

  AdminModel? getAdminByEmail(String email) {
    try {
      return _adminList.firstWhere((admin) => admin.email == email);
    } catch (e) {
      // print('Admin not found: $email');
      return null;
    }
  }

  List<AdminModel> getAllAdmins() {
    return List.unmodifiable(_adminList);
  }

  void updateAdmin(String email, AdminModel updatedAdmin) {
    for (int i = 0; i < _adminList.length; i++) {
      if (_adminList[i].email == email) {
        _adminList[i] = updatedAdmin;
        // print('Admin updated: ${updatedAdmin.name}');
        return;
      }
    }
    // print('Admin with email $email not found.');
  }

  bool adminExists(String email) {
    return _adminList.any((admin) => admin.email == email);
  }

  void clearAllAdmins() {
    _adminList.clear();
    // print('All admins removed.');
  }

  Future<void> assignCustomersAutomatically() async {
    try {
      // **1️⃣ Personel ve Müşteri Verilerini Oku**
      final String personnelData =
          await rootBundle.loadString('assets/personnel.json');
      final String customerData =
          await rootBundle.loadString('assets/users.json');

      List<dynamic> personnelList = json.decode(personnelData);
      List<dynamic> customerList = json.decode(customerData);

      if (personnelList.isEmpty || customerList.isEmpty) {
        // print("🚨 Atama başarısız: Personel veya müşteri listesi boş!");
        return;
      }

      Random random = Random();

      // **2️⃣ Atama Yapılacak Veri Yapıları**
      List<dynamic> updatedCustomers =
          List.from(customerList); // Müşteri listesini kopyala
      List<dynamic> updatedPersonnels = personnelList.map((p) {
        return {
          ...p,
          "assigned_customers": [] // Yeni atanan müşterileri buraya ekleyeceğiz
        };
      }).toList();

      // **3️⃣ Müşterileri Personellere Rastgele Ata**
      for (var customer in updatedCustomers) {
        int randomIndex = random.nextInt(updatedPersonnels.length);
        var assignedPersonel =
            updatedPersonnels[randomIndex]; // Rastgele personel seç
        String assignedToEmail = assignedPersonel["email"];
        int customerId = customer["id"];

        // **Müşterinin 'assigned_to' alanını güncelle**
        customer["assigned_to"] = assignedToEmail;

        // **Personelin 'assigned_customers' listesine ekle**
        assignedPersonel["assigned_customers"].add(customerId);

        // print(
        //     "✅ ${customer["name"]} müşterisi $assignedToEmail personeline atandı.");
      }

      // print("📌 Atama işlemi tamamlandı!");

      // **4️⃣ JSON Dosyalarını İndir**
      // _downloadJsonFile(updatedCustomers, "updated_customers.json");
      // _downloadJsonFile(updatedPersonnels, "updated_personnels.json");
    } catch (e) {
      // print("❌ Hata: $e");
    }
  }

// **JSON Dosyasını Tarayıcıdan İndirme Fonksiyonu**
  // void _downloadJsonFile(dynamic data, String fileName) {
  //   final jsonString = jsonEncode(data);
  //   final blob = html.Blob([jsonString], 'application/json');
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   final anchor = html.AnchorElement(href: url)
  //     ..setAttribute("download", fileName)
  //     ..click();
  //   html.Url.revokeObjectUrl(url);
  // }
}

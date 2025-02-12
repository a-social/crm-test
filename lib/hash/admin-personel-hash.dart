import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

// 🔑 SHA-512 Hash Fonksiyonu
String hashPassword(String password) {
  return sha512.convert(utf8.encode(password)).toString();
}

void main() {
  // 📌 Admin Listesi
  List<Map<String, dynamic>> admins = [
    {
      "id": 1,
      "name": "Süper Admin",
      "email": "admin1@example.com",
      "password": hashPassword("superadmin123"),
      "role": "admin",
      "created_at": DateTime.now().toIso8601String()
    },
    {
      "id": 2,
      "name": "İkinci Admin",
      "email": "admin2@example.com",
      "password": hashPassword("adminpass456"),
      "role": "admin",
      "created_at": DateTime.now().toIso8601String()
    }
  ];

  // 📌 Personel Listesi
  List<Map<String, dynamic>> personnel = [
    {
      "id": 101,
      "name": "Ahmet Yılmaz",
      "email": "ahmet@company.com",
      "password": hashPassword("ahmet123"),
      "phone": "+905551112233",
      "role": "personel",
      "assigned_customers": [],
      "total_investment": 0,
      "created_at": DateTime.now().toIso8601String()
    },
    {
      "id": 102,
      "name": "Zeynep Kaya",
      "email": "zeynep@company.com",
      "password": hashPassword("zeynep456"),
      "phone": "+905552223344",
      "role": "personel",
      "assigned_customers": [],
      "total_investment": 0,
      "created_at": DateTime.now().toIso8601String()
    }
  ];

  // 📌 Klasör ve Dosyaları Kontrol Etme
  Directory assetsDir = Directory("assets");
  if (!assetsDir.existsSync()) {
    assetsDir.createSync();
  }

  // 📌 Admin ve Personel JSON Dosyalarını Yaz
  File adminFile = File("assets/admin.json");
  adminFile.writeAsStringSync(jsonEncode(admins), mode: FileMode.write);

  File personnelFile = File("assets/personnel.json");
  personnelFile.writeAsStringSync(jsonEncode(personnel), mode: FileMode.write);

  print("✅ SHA-512 ile hashlenmiş admin ve personel dosyaları oluşturuldu.");
}

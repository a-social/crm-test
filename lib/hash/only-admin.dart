import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  return sha512.convert(utf8.encode(password)).toString();
}

void main() {
  List<Map<String, dynamic>> admins = [
    {
      "name": "Süper Admin",
      "email": "admin1@example.com",
      "password": hashPassword("anneannenisikeyim"),
      "role": "admin",
      "created_at": DateTime.now().toIso8601String()
    },
    {
      "name": "İkinci Admin",
      "email": "admin2@example.com",
      "password": hashPassword("superadmin"),
      "role": "admin",
      "created_at": DateTime.now().toIso8601String()
    },
    {
      "name": "Üçüncü Admin",
      "email": "admin3@example.com",
      "password": hashPassword("securepass"),
      "role": "admin",
      "created_at": DateTime.now().toIso8601String()
    }
  ];

  File adminFile = File("assets/personnel.json");
  adminFile.writeAsStringSync(jsonEncode(admins), mode: FileMode.write);
  print("✅ SHA-512 ile hashlenmiş admin.json dosyası oluşturuldu.");
}

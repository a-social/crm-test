import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  return sha512.convert(utf8.encode(password)).toString();
}

void main() {
  List<Map<String, dynamic>> personnel = [
    {
      "id": 2,
      "name": "Kenan Yılmaz",
      "email": "Kenan@company.com",
      "password": hashPassword("keno1234"),
      "phone": "+905416523652",
      "role": "personel",
      "assigned_customers": [],
      "total_investment": 0,
      "created_at": DateTime.now().toIso8601String()
    }
  ];

  File personnelFile = File("assets/personnel.json");
  personnelFile.writeAsStringSync(jsonEncode(personnel), mode: FileMode.write);
  print("✅ SHA-512 ile hashlenmiş personnel.json dosyası oluşturuldu.");
}

import 'dart:convert';
import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:bcrypt/bcrypt.dart';

class MongoDB {
  static late Db _db;
  static late DbCollection customersCollection;
  static late DbCollection adminsCollection;

  // MongoDB'ye bağlan
  static Future<void> connect() async {
    _db = await Db.create("mongodb://94.79.95.58:27017/crm_database");
    await _db.open();

    customersCollection = _db.collection("customers");
    adminsCollection = _db.collection("admins");

    print("MongoDB bağlantısı başarılı!");
  }

  // JSON dosyasını oku ve MongoDB'ye aktar
  static Future<void> importFromJson(String filePath) async {
    try {
      final file = File(filePath);
      String content = await file.readAsString();
      Map<String, dynamic> jsonData = jsonDecode(content);

      // Müşterileri ekle
      for (var customer in jsonData["customers"]) {
        await customersCollection.insertOne(customer);
      }

      // Adminleri ekle (şifreleri hashleyerek)
      for (var admin in jsonData["admins"]) {
        String hashedPassword =
            BCrypt.hashpw(admin["password"], BCrypt.gensalt());
        admin["password"] = hashedPassword; // Hashlenmiş şifreyi ekle
        await adminsCollection.insertOne(admin);
      }

      print("JSON verisi başarıyla MongoDB'ye aktarıldı.");
    } catch (e) {
      print("JSON okuma hatası: $e");
    }
  }

  // Tüm müşterileri listeleme
  static Future<void> getCustomers() async {
    var customers = await customersCollection.find().toList();
    print("Müşteriler: $customers");
  }

  // Tüm adminleri listeleme
  static Future<void> getAdmins() async {
    var admins = await adminsCollection.find().toList();
    print("Adminler: $admins");
  }
}

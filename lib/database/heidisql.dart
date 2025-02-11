import 'package:mysql1/mysql1.dart';

class HeidiSQL {
  static late MySqlConnection _conn;

  // Veritabanı bağlantı bilgileri
  static final ConnectionSettings settings = ConnectionSettings(
    host: 'localhost', // veya uzaktaki bir IP
    port: 3306,
    user: 'root', // veya kendi MySQL kullanıcı adın
    db: 'crm_database', // veya kendi veritabanı adın
  );

  // Bağlantıyı başlat
  static Future<void> connect() async {
    _conn = await MySqlConnection.connect(settings);
    print("✅ HeidiSQL (MySQL) bağlantısı başarılı!");
  }

  // Müşteri ekleme
  static Future<void> addCustomer(
      String name, String phone, String email) async {
    await _conn.query(
        'INSERT INTO customers (name, phone, email) VALUES (?, ?, ?)',
        [name, phone, email]);
    print("✅ Müşteri eklendi: $name");
  }

  // Tüm müşterileri listeleme
  static Future<void> getCustomers() async {
    var results = await _conn.query('SELECT * FROM customers');
    for (var row in results) {
      print(
          '📌 Müşteri: ${row['name']}, Telefon: ${row['phone']}, Email: ${row['email']}');
    }
  }
}

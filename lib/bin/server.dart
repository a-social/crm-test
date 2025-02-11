import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  // **SQLite için FFI başlatma**
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  var db = await databaseFactory.openDatabase(inMemoryDatabasePath);

  // **Kullanıcı tablosunu oluştur (Admin ve Normal Kullanıcılar)**
  await db.execute('''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT, 
      email TEXT UNIQUE, 
      password TEXT, 
      position TEXT
    )
  ''');

  // **Personel JSON dosyasının yolunu tanımla**
  final String personnelFilePath = 'assets/personnel.json';

  // **Eğer assets klasörü yoksa oluştur**
  final Directory assetsDir = Directory('assets');
  if (!assetsDir.existsSync()) {
    assetsDir.createSync();
  }

  // **Eğer personnel.json dosyası yoksa, boş bir liste oluştur**
  final File personnelFile = File(personnelFilePath);
  if (!personnelFile.existsSync()) {
    personnelFile.writeAsStringSync(jsonEncode([])); // Boş JSON array oluştur
  }

  // **Router oluştur (Tüm API işlemleri buraya eklenecek)**
  final router = Router();

  // 📌 1. Kullanıcıları Listeleme (SQLite)
  router.get('/users', (Request request) async {
    try {
      var users = await db.rawQuery('SELECT * FROM users');
      return Response.ok(jsonEncode(users),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  // 📌 2. Kullanıcı Ekleme (SQLite) → **Password ve Position ekledik**
  router.post('/add-user', (Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      if (!data.containsKey('name') ||
          !data.containsKey('email') ||
          !data.containsKey('password') ||
          !data.containsKey('position')) {
        return Response(400,
            body: 'Eksik alanlar: name, email, password, position');
      }

      String name = data['name'];
      String email = data['email'];
      String password = data['password'];
      String position = data['position'];

      await db.insert('users', {
        'name': name,
        'email': email,
        'password': password,
        'position': position
      });

      return Response.ok(
          jsonEncode({
            "status": "success",
            "message": "Kullanıcı eklendi",
            "user": {"name": name, "email": email, "position": position}
          }),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  // 📌 3. Admin - Personelleri Listeleme (`assets/personnel.json` içinden)
  router.get('/admin/personnel', (Request request) async {
    try {
      final jsonData = jsonDecode(await personnelFile.readAsString());
      return Response.ok(jsonEncode(jsonData),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  // 📌 4. Admin - Yeni Personel Ekleme (`assets/personnel.json` içine yazma)
  router.post('/admin/add-personnel', (Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      if (!data.containsKey('name') ||
          !data.containsKey('email') ||
          !data.containsKey('password') ||
          !data.containsKey('position')) {
        return Response(400,
            body: 'Eksik alanlar: name, email, password, position');
      }

      final String name = data['name'];
      final String email = data['email'];
      final String password = data['password'];
      final String position = data['position'];

      // **JSON dosyasındaki mevcut personelleri oku**
      List<dynamic> personnelList =
          jsonDecode(await personnelFile.readAsString());

      // **Yeni personeli listeye ekle**
      personnelList.add({
        'name': name,
        'email': email,
        'password': password,
        'position': position
      });

      // **JSON dosyasına güncellenmiş listeyi yaz**
      await personnelFile.writeAsString(jsonEncode(personnelList));

      return Response.ok(
          jsonEncode({
            "status": "success",
            "message": "Personel eklendi",
            "personnel": {"name": name, "email": email, "position": position}
          }),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  // 📌 5. Admin - Personel Silme (`assets/personnel.json` içinden)
  router.delete('/admin/delete-personnel/<email>',
      (Request request, String email) async {
    try {
      List<dynamic> personnelList =
          jsonDecode(await personnelFile.readAsString());

      // **Silinecek personeli listeden çıkar**
      personnelList.removeWhere((person) => person['email'] == email);

      // **Güncellenmiş JSON dosyasını kaydet**
      await personnelFile.writeAsString(jsonEncode(personnelList));

      return Response.ok(
          jsonEncode({"status": "success", "message": "Personel silindi"}));
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  // Middleware ekleme (CORS + Logging)
  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware)
      .addHandler(router.call);

  // **Sunucuyu başlat**
  var server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('✅ Server running on http://${server.address.host}:${server.port}');
}

// ✅ CORS Middleware Tanımlama
final Middleware corsMiddleware = (Handler innerHandler) {
  return (Request request) async {
    if (request.method == 'OPTIONS') {
      return Response.ok('', headers: _corsHeaders);
    }
    final Response response = await innerHandler(request);
    return response.change(headers: {...response.headers, ..._corsHeaders});
  };
};

// ✅ CORS Headers Tanımlama
const Map<String, String> _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
};

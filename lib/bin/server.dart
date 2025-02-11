import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  // SQLite için FFI başlatma
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  var db = await databaseFactory.openDatabase(inMemoryDatabasePath);

  // Admin tablosunu oluştur
  await db.execute('''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY, 
      name TEXT, 
      email TEXT UNIQUE
    )
  ''');

  // Router oluştur
  final router = Router();

  // 📌 1. Admin Kullanıcılarını Listeleme
  router.get('/admin/users', (Request request) async {
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

  // 📌 2. Tüm Personelleri Listeleme (JSON Dosyasından)
  router.get('/admin/personnel', (Request request) async {
    try {
      final File file = File('personnel.json');
      if (!file.existsSync()) {
        return Response.ok(jsonEncode([]),
            headers: {'Content-Type': 'application/json'});
      }
      final jsonData = jsonDecode(await file.readAsString());
      return Response.ok(jsonEncode(jsonData),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  // 📌 3. Yeni Personel Ekleme (JSON Dosyasına Yazma)
  router.post('/admin/add-personnel', (Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      if (!data.containsKey('name') ||
          !data.containsKey('email') ||
          !data.containsKey('password')) {
        return Response(400, body: 'Eksik alanlar: name, email, password');
      }

      final String name = data['name'];
      final String email = data['email'];
      final String password = data['password'];

      final File file = File('personnel.json');

      List<dynamic> personnelList = [];
      if (file.existsSync()) {
        personnelList = jsonDecode(await file.readAsString());
      }

      personnelList.add({'name': name, 'email': email, 'password': password});

      await file.writeAsString(jsonEncode(personnelList));

      return Response.ok(
          jsonEncode({
            "status": "success",
            "message": "Personel eklendi",
            "personnel": {"name": name, "email": email}
          }),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  // 📌 4. Personel Silme (JSON Dosyasından)
  router.delete('/admin/delete-personnel/<email>',
      (Request request, String email) async {
    try {
      final File file = File('personnel.json');

      if (!file.existsSync()) {
        return Response.notFound(jsonEncode({"error": "Personel bulunamadı"}));
      }

      List<dynamic> personnelList = jsonDecode(await file.readAsString());
      personnelList.removeWhere((person) => person['email'] == email);

      await file.writeAsString(jsonEncode(personnelList));

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
      .addMiddleware(logRequests()) // HTTP loglarını gösterir
      .addMiddleware(corsMiddleware) // ✅ CORS middleware eklendi
      .addHandler(router.call);

  // Sunucuyu başlat
  var server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('✅ Server running on http://${server.address.host}:${server.port}');
}

// ✅ CORS Middleware Tanımlama
final Middleware corsMiddleware = (Handler innerHandler) {
  return (Request request) async {
    // Eğer `OPTIONS` isteği gelirse direkt 200 döndür
    if (request.method == 'OPTIONS') {
      return Response.ok('', headers: _corsHeaders);
    }

    // Normal isteklere CORS header'ları ekleyerek cevap dön
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

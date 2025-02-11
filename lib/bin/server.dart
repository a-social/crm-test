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
  await db.execute('''
    CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, email TEXT)
  ''');

  // Router oluşturma
  final router = Router();

  // Kullanıcıları getiren endpoint
  router.get('/users', (Request request) async {
    var users = await db.rawQuery('SELECT * FROM users');
    return Response.ok(users.toString(),
        headers: {'Content-Type': 'application/json'});
  });

  // Kullanıcı ekleyen endpoint
  router.post('/add-user', (Request request) async {
    var name = 'User ${DateTime.now().millisecondsSinceEpoch}';
    var email = '$name@example.com';
    await db.rawInsert(
        'INSERT INTO users (name, email) VALUES (?, ?)', [name, email]);
    return Response.ok('User added: $name');
  });

  // Middleware ekleme (CORS + Logging)
  var handler = const Pipeline()
      .addMiddleware(logRequests()) // HTTP loglarını gösterir
      .addMiddleware(corsMiddleware) // ✅ CORS middleware eklendi
      .addHandler(router);

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

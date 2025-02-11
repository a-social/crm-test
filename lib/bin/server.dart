import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

const String secretKey = "superSecretKey"; // JWT Secret Key

String generateJWT(String email, String role) {
  final claimSet = JwtClaim(
    issuer: 'your_server',
    subject: email,
    otherClaims: {'role': role},
    maxAge: const Duration(days: 1),
  );

  return issueJwtHS256(claimSet, secretKey);
}

bool verifyJWT(String token) {
  try {
    final JwtClaim claimSet = verifyJwtHS256Signature(token, secretKey);
    claimSet.validate(issuer: 'your_server');
    return true;
  } catch (e) {
    return false;
  }
}

bool isAdmin(String token) {
  try {
    final JwtClaim claimSet = verifyJwtHS256Signature(token, secretKey);
    final String role = claimSet.payload['role'];
    return role == "admin";
  } catch (e) {
    return false;
  }
}

void logAction(String action) {
  final logFile = File('logs.txt');
  final logEntry = "[${DateTime.now()}] $action\n";
  logFile.writeAsStringSync(logEntry, mode: FileMode.append);
}

void main() async {
  final String personnelFilePath = 'assets/personnel.json';
  final String usersFilePath = 'assets/users.json';
  final String adminFilePath = 'assets/admin.json';

  final Directory assetsDir = Directory('assets');
  if (!assetsDir.existsSync()) {
    assetsDir.createSync();
  }

  final File personnelFile = File(personnelFilePath);
  if (!personnelFile.existsSync()) {
    personnelFile.writeAsStringSync(jsonEncode([]));
  }

  final File usersFile = File(usersFilePath);
  if (!usersFile.existsSync()) {
    usersFile.writeAsStringSync(jsonEncode([]));
  }

  final File adminFile = File(adminFilePath);
  if (!adminFile.existsSync()) {
    adminFile.writeAsStringSync(jsonEncode([]));
  }

  final router = Router();

  router.post('/admin-login', (Request request) async {
    try {
      final payload = await request.readAsString();

      if (payload.isEmpty) {
        return Response.badRequest(
            body: jsonEncode({"error": "Boş istek gönderildi"}));
      }

      final Map<String, dynamic> data = jsonDecode(payload);

      if (!data.containsKey('email') || !data.containsKey('password')) {
        return Response.badRequest(
            body: jsonEncode({"error": "Email ve şifre zorunludur"}));
      }

      final String email = data['email'];
      final String password = data['password'];

      final List<dynamic> adminList =
          jsonDecode(await adminFile.readAsString());

      final admin = adminList.firstWhere(
          (a) => a['email'] == email && a['password'] == password,
          orElse: () => null);

      if (admin == null) {
        return Response.forbidden(
            jsonEncode({"error": "Geçersiz email veya şifre"}));
      }

      final String token = generateJWT(email, "admin");

      return Response.ok(jsonEncode({"token": token}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": "Sunucu hatası: ${e.toString()}"}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  router.post('/login', (Request request) async {
    try {
      final payload = await request.readAsString();

      if (payload.isEmpty) {
        return Response.badRequest(
            body: jsonEncode({"error": "Boş istek gönderildi"}));
      }

      final Map<String, dynamic> data = jsonDecode(payload);

      if (!data.containsKey('email') || !data.containsKey('password')) {
        return Response.badRequest(
            body: jsonEncode({"error": "Email ve şifre zorunludur"}));
      }

      final String? email = data['email'];
      final String? password = data['password'];

      if (email == null || password == null) {
        return Response.badRequest(
            body: jsonEncode({"error": "Email veya şifre null olamaz"}));
      }

      final List<dynamic> personnelList =
          jsonDecode(await personnelFile.readAsString());

      final person = personnelList.firstWhere(
          (p) => p['email'] == email && p['password'] == password,
          orElse: () => null);

      if (person == null) {
        return Response.forbidden(
            jsonEncode({"error": "Geçersiz email veya şifre"}));
      }

      final String token = generateJWT(email, "personel");

      return Response.ok(jsonEncode({"token": token}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": "Sunucu hatası: ${e.toString()}"}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  router.get('/users', (Request request) async {
    final token = request.headers['Authorization'];
    if (token == null || !verifyJWT(token)) {
      return Response.forbidden(jsonEncode({"error": "Yetkisiz işlem"}));
    }

    final jsonData = jsonDecode(await usersFile.readAsString());
    return Response.ok(jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'});
  });

  router.post('/add-user', (Request request) async {
    final token = request.headers['Authorization'];
    if (token == null || !verifyJWT(token)) {
      return Response.forbidden(jsonEncode({"error": "Yetkisiz işlem"}));
    }

    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    if (!data.containsKey('name') ||
        !data.containsKey('email') ||
        !data.containsKey('phone') ||
        !data.containsKey('trade_status')) {
      return Response(400,
          body: 'Eksik alanlar: name, email, phone, trade_status');
    }

    final String name = data['name'];
    final String email = data['email'];
    final String phone = data['phone'];
    final bool tradeStatus = data['trade_status'];

    List<dynamic> userList = jsonDecode(await usersFile.readAsString());

    userList.add({
      'name': name,
      'email': email,
      'phone': phone,
      'trade_status': tradeStatus,
      'investment_status': false,
      'created_at': DateTime.now().toIso8601String()
    });

    await usersFile.writeAsString(jsonEncode(userList));

    logAction("Yeni kullanıcı eklendi: $name ($email)");

    return Response.ok(
        jsonEncode({"status": "success", "message": "Kullanıcı eklendi"}),
        headers: {'Content-Type': 'application/json'});
  });

  router.put('/update-user/<email>', (Request request, String email) async {
    final token = request.headers['Authorization'];
    if (token == null || !verifyJWT(token)) {
      return Response.forbidden(jsonEncode({"error": "Yetkisiz işlem"}));
    }

    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    List<dynamic> userList = jsonDecode(await usersFile.readAsString());

    bool userFound = false;

    for (var user in userList) {
      if (user['email'] == email) {
        user.addAll(data);
        userFound = true;
        break;
      }
    }

    if (!userFound) {
      return Response.notFound(jsonEncode({"error": "Kullanıcı bulunamadı"}));
    }

    await usersFile.writeAsString(jsonEncode(userList));

    logAction("Kullanıcı güncellendi: $email");

    return Response.ok(
        jsonEncode({"status": "success", "message": "Kullanıcı güncellendi"}));
  });

  // 📌 Kullanıcı Silme (Sadece Admin)
  router.delete('/delete-user/<email>', (Request request, String email) async {
    final token = request.headers['Authorization'];
    if (token == null || !verifyJWT(token)) {
      return Response.forbidden(jsonEncode({"error": "Yetkisiz işlem"}));
    }

    if (!isAdmin(token)) {
      return Response.forbidden(
          jsonEncode({"error": "Sadece adminler kullanıcı silebilir"}));
    }

    List<dynamic> userList = jsonDecode(await usersFile.readAsString());

    int initialLength = userList.length;
    userList.removeWhere((user) => user['email'] == email);

    if (userList.length == initialLength) {
      return Response.notFound(jsonEncode({"error": "Kullanıcı bulunamadı"}));
    }

    await usersFile.writeAsString(jsonEncode(userList));

    logAction("Admin kullanıcısı silindi: $email");

    return Response.ok(
        jsonEncode({"status": "success", "message": "Kullanıcı silindi"}));
  });

  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware)
      .addHandler(router.call);

  var server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('✅ Server running on http://${server.address.host}:${server.port}');
}

final Middleware corsMiddleware = (Handler innerHandler) {
  return (Request request) async {
    if (request.method == 'OPTIONS') {
      return Response.ok('', headers: _corsHeaders);
    }
    final Response response = await innerHandler(request);
    return response.change(headers: {...response.headers, ..._corsHeaders});
  };
};

const Map<String, String> _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
};

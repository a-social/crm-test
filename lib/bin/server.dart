import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  // **Dosya yolları tanımlandı**
  final String personnelFilePath = 'assets/personnel.json';
  final String usersFilePath = 'assets/users.json';

  // **Eğer assets klasörü yoksa oluştur**
  final Directory assetsDir = Directory('assets');
  if (!assetsDir.existsSync()) {
    assetsDir.createSync();
  }

  // **Eğer JSON dosyaları yoksa, boş bir liste olarak oluştur**
  final File personnelFile = File(personnelFilePath);
  if (!personnelFile.existsSync()) {
    personnelFile.writeAsStringSync(jsonEncode([]));
  }

  final File usersFile = File(usersFilePath);
  if (!usersFile.existsSync()) {
    usersFile.writeAsStringSync(jsonEncode([]));
  }

  // **Router oluştur**
  final router = Router();

  // 📌 1. Kullanıcıları Listeleme (`assets/users.json`)
  router.get('/users', (Request request) async {
    try {
      final jsonData = jsonDecode(await usersFile.readAsString());
      return Response.ok(jsonEncode(jsonData),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  // 📌 2. Yeni Kullanıcı Ekleme (`assets/users.json` içine yazma)
  router.post('/add-user', (Request request) async {
    try {
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

      // Kullanıcıya başlangıçta yatırım yapmadı (false) bilgisi ekleniyor
      userList.add({
        'name': name,
        'email': email,
        'phone': phone,
        'trade_status': tradeStatus,
        'investment_status': false // Varsayılan olarak "yatırım yapmadı"
      });

      await usersFile.writeAsString(jsonEncode(userList));

      return Response.ok(
          jsonEncode({
            "status": "success",
            "message": "Kullanıcı eklendi",
            "user": {
              "name": name,
              "email": email,
              "phone": phone,
              "trade_status": tradeStatus,
              "investment_status": false
            }
          }),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  // 📌 3. Kullanıcının `investment_status` Bilgisini Güncelleme (Personel Kullanacak)
  router.put('/update-investment-status/<email>',
      (Request request, String email) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      if (!data.containsKey('investment_status')) {
        return Response(400, body: 'Eksik alan: investment_status');
      }

      final bool newInvestmentStatus = data['investment_status'];

      List<dynamic> userList = jsonDecode(await usersFile.readAsString());

      bool userFound = false;

      for (var user in userList) {
        if (user['email'] == email) {
          user['investment_status'] = newInvestmentStatus;
          userFound = true;
          break;
        }
      }

      if (!userFound) {
        return Response.notFound(jsonEncode({"error": "Kullanıcı bulunamadı"}));
      }

      await usersFile.writeAsString(jsonEncode(userList));

      return Response.ok(jsonEncode(
          {"status": "success", "message": "Yatırım durumu güncellendi"}));
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  // 📌 4. Admin - Kullanıcı İstatistiklerini Getirme
  router.get('/admin/stats', (Request request) async {
    try {
      final List<dynamic> userList = jsonDecode(await usersFile.readAsString());

      int totalUsers = userList.length;
      int investedUsers =
          userList.where((user) => user['investment_status'] == true).length;

      return Response.ok(
          jsonEncode(
              {"total_users": totalUsers, "invested_users": investedUsers}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": e.toString()}),
          headers: {'Content-Type': 'application/json'});
    }
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

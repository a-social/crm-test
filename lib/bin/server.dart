import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:dotenv/dotenv.dart';
import 'package:crypto/crypto.dart';

final env = DotEnv()..load();

// 🔐 Güvenli JWT Yönetimi
String generateRandomSecretKey() {
  final bytes = utf8.encode(DateTime.now().toIso8601String());
  return base64Url.encode(sha512.convert(bytes).bytes);
}

final String secretKey = env['JWT_SECRET'] ?? generateRandomSecretKey();

// 🔑 SHA-512 Hash Fonksiyonu
String hashPassword(String password) {
  return sha512.convert(utf8.encode(password)).toString();
}

// 🎫 JWT Token Oluşturma
String generateJWT(String email, String role) {
  final claimSet = JwtClaim(
    issuer: 'crm_server',
    subject: email,
    otherClaims: {'role': sha256.convert(utf8.encode(role)).toString()},
    issuedAt: DateTime.now(),
    maxAge: const Duration(days: 1),
  );

  return issueJwtHS256(claimSet, secretKey);
}

// 🔍 JWT Token Doğrulama
bool verifyJWT(String token) {
  try {
    final JwtClaim claimSet = verifyJwtHS256Signature(token, secretKey);
    claimSet.validate(issuer: 'crm_server');
    return true;
  } catch (e) {
    print("JWT Doğrulama Hatası: $e");
    return false;
  }
}

// 🔑 Kullanıcının Admin olup olmadığını kontrol et
bool isAdmin(String token) {
  try {
    final JwtClaim claimSet = verifyJwtHS256Signature(token, secretKey);
    claimSet.validate(issuer: 'crm_server');
    final Map<String, dynamic> claims = claimSet.toJson();
    String hashedAdminRole = sha256.convert(utf8.encode("admin")).toString();
    return claims['role'] == hashedAdminRole;
  } catch (e) {
    return false;
  }
}

// 📝 Log Kayıt Fonksiyonu
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
  final File usersFile = File(usersFilePath);
  final File adminFile = File(adminFilePath);

  final router = Router();

  // 📌 Admin Login
  router.post('/admin-login', (Request request) async {
    final payload = await request.readAsString();
    final Map<String, dynamic> data = jsonDecode(payload);
    final String email = data['email'];
    final String password = data['password'];

    final List<dynamic> adminList = jsonDecode(await adminFile.readAsString());
    final admin = adminList.firstWhere(
        (a) => a['email'] == email && a['password'] == hashPassword(password),
        orElse: () => null);

    if (admin == null) {
      return Response.forbidden(
          jsonEncode({"error": "Geçersiz email veya şifre"}));
    }

    final String token = generateJWT(email, "admin");
    return Response.ok(jsonEncode({"token": token}),
        headers: {'Content-Type': 'application/json'});
  });

  // 📌 Personel Login
  router.post('/login', (Request request) async {
    try {
      final payload = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(payload);

      // 📌 E-posta ve şifre kontrolü
      if (!data.containsKey('email') || !data.containsKey('password')) {
        return Response.badRequest(
            body: jsonEncode({"error": "Email ve şifre zorunludur"}));
      }

      final String email = data['email'];
      final String password = data['password'];

      // 📌 personnel.json dosyasını oku
      if (!personnelFile.existsSync()) {
        return Response.internalServerError(
            body: jsonEncode({"error": "personnel.json bulunamadı!"}));
      }

      final String fileContent = await personnelFile.readAsString();
      if (fileContent.isEmpty) {
        return Response.internalServerError(
            body: jsonEncode({"error": "personnel.json boş!"}));
      }

      List<dynamic> personnelList;
      try {
        personnelList = jsonDecode(fileContent);
      } catch (e) {
        return Response.internalServerError(
            body: jsonEncode({"error": "personnel.json bozuk!"}));
      }

      // 📌 Kullanıcıyı bul ve şifreyi karşılaştır
      List<dynamic> foundUsers = personnelList
          .where((p) =>
              p['email'] == email && p['password'] == hashPassword(password))
          .toList();

      if (foundUsers.isEmpty) {
        return Response.forbidden(
            jsonEncode({"error": "Geçersiz email veya şifre"}));
      }

      // 📌 Token oluştur
      final String token = generateJWT(email, "personel");

      return Response.ok(jsonEncode({"token": token}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({"error": "Sunucu hatası: ${e.toString()}"}));
    }
  });

  // 📌 Tüm Kullanıcıları Listeleme
  router.get('/users', (Request request) async {
    final token = request.headers['Authorization'];

    if (token == null) {
      print("⛔ HATA: Token bulunamadı!");
      return Response.forbidden(
          jsonEncode({"error": "Yetkisiz işlem - Token Eksik"}));
    }

    final tokenValue = token.replaceFirst('Bearer ', '').trim();

    if (!verifyJWT(tokenValue)) {
      print("⛔ HATA: Token doğrulaması başarısız oldu!");
      return Response.forbidden(
          jsonEncode({"error": "Yetkisiz işlem - Token Geçersiz"}));
    }

    if (!isAdmin(tokenValue)) {
      print("⛔ HATA: Kullanıcı admin değil!");
      return Response.forbidden(
          jsonEncode({"error": "Bu işlem için yetkiniz yok"}));
    }

    print("✅ Başarılı: Admin yetkisi doğrulandı!");
    final jsonData = jsonDecode(await usersFile.readAsString());
    return Response.ok(jsonEncode(jsonData),
        headers: {'Content-Type': 'application/json'});
  });

  // 📌 Yeni Kullanıcı Ekleme
  router.post('/add-user', (Request request) async {
    final token = request.headers['Authorization'];

    if (token == null) {
      print("⛔ HATA: Token bulunamadı!");
      return Response.forbidden(
          jsonEncode({"error": "Yetkisiz işlem - Token Eksik"}));
    }

    final tokenValue = token.replaceFirst('Bearer ', '').trim();

    if (!verifyJWT(tokenValue)) {
      print("⛔ HATA: Token doğrulaması başarısız oldu!");
      return Response.forbidden(
          jsonEncode({"error": "Yetkisiz işlem - Token Geçersiz"}));
    }

    if (!isAdmin(tokenValue)) {
      print("⛔ HATA: Kullanıcı admin değil!");
      return Response.forbidden(
          jsonEncode({"error": "Bu işlem için yetkiniz yok"}));
    }

    print("✅ Başarılı: Admin yetkisi doğrulandı!");

    final payload = await request.readAsString();
    final Map<String, dynamic> data = jsonDecode(payload);

    // 📌 Gerekli Alanları Kontrol Et
    if (!data.containsKey('name') ||
        !data.containsKey('email') ||
        !data.containsKey('phone') ||
        !data.containsKey('assigned_to')) {
      print("⛔ HATA: Eksik alanlar tespit edildi!");
      return Response(400,
          body: jsonEncode(
              {"error": "Eksik alanlar: name, email, phone, assigned_to"}));
    }

    print("✅ Yeni kullanıcı ekleniyor: ${data['email']}");

    List<dynamic> userList = jsonDecode(await usersFile.readAsString());

    // 📌 Yeni Kullanıcıyı JSON Formatına Uygun Olarak Ekle
    Map<String, dynamic> newUser = {
      "id": userList.isNotEmpty
          ? (userList.last['id'] ?? 100) + 1
          : 101, // Yeni ID oluştur
      "name": data["name"],
      "email": data["email"],
      "phone": data["phone"],
      "trade_status": data["trade_status"] ?? false,
      "investment_status": data["investment_status"] ?? false,
      "investment_amount": data["investment_amount"] ?? 0,
      "assigned_to": data["assigned_to"],
      "call_duration": data["call_duration"] ?? 0,
      "phone_status": data["phone_status"] ?? "Bilinmiyor",
      "previous_investment": data["previous_investment"] ?? false,
      "expected_investment_date": data["expected_investment_date"] ?? null,
      "created_at": DateTime.now().toIso8601String(),
    };

    userList.add(newUser);

    await usersFile.writeAsString(jsonEncode(userList));

    logAction("Yeni kullanıcı eklendi: ${data['name']} (${data['email']})");

    return Response.ok(
        jsonEncode({
          "status": "success",
          "message": "Kullanıcı eklendi",
          "user": newUser
        }),
        headers: {'Content-Type': 'application/json'});
  });

  // 📌 Kullanıcı Güncelleme
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
    if (token == null || !verifyJWT(token) || !isAdmin(token)) {
      return Response.forbidden(jsonEncode({"error": "Yetkisiz işlem"}));
    }

    List<dynamic> userList = jsonDecode(await usersFile.readAsString());

    userList.removeWhere((user) => user['email'] == email);

    await usersFile.writeAsString(jsonEncode(userList));

    logAction("Admin kullanıcısı silindi: $email");

    return Response.ok(
        jsonEncode({"status": "success", "message": "Kullanıcı silindi"}));
  });

  // 📌 Admin Paneli (Gelişmiş İstatistikler)
  router.get('/admin', (Request request) async {
    final String? authHeader = request.headers['Authorization'];

    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response.forbidden(jsonEncode({"error": "Yetkisiz işlem"}));
    }

    final String jwtToken = authHeader.replaceFirst('Bearer ', '');

    if (!verifyJWT(jwtToken) || !isAdmin(jwtToken)) {
      return Response.forbidden(
          jsonEncode({"error": "Bu işlem için yetkiniz yok"}));
    }

    // 📌 JSON dosyalarını tanımla
    final File personnelFile = File('assets/personnel.json');
    final File usersFile = File('assets/users.json');

    List<dynamic> userList = [];
    List<dynamic> personnelList = [];

    if (personnelFile.existsSync()) {
      final String personnelContent = await personnelFile.readAsString();
      if (personnelContent.isNotEmpty) {
        try {
          personnelList = jsonDecode(personnelContent);
        } catch (e) {
          return Response.internalServerError(
              body: jsonEncode({"error": "personnel.json bozuk!"}));
        }
      }
    }

    if (usersFile.existsSync()) {
      final String usersContent = await usersFile.readAsString();
      if (usersContent.isNotEmpty) {
        try {
          userList = jsonDecode(usersContent);
        } catch (e) {
          return Response.internalServerError(
              body: jsonEncode({"error": "users.json bozuk!"}));
        }
      }
    }

    // 📌 Toplam müşteri ve personel sayısı
    int totalCustomers = userList.length;
    int totalPersonnel = personnelList.length;

    // 📌 Son 7 gün içinde eklenen müşterileri say
    DateTime now = DateTime.now();
    int last7DaysCustomers = userList.where((user) {
      if (user.containsKey('created_at')) {
        DateTime createdAt = DateTime.parse(user['created_at']);
        return now.difference(createdAt).inDays <= 7;
      }
      return false;
    }).length;

    // 📌 Son 30 gün içinde yapılan toplam yatırım miktarı
    double last30DaysInvestment = userList.fold(0, (sum, user) {
      if (user.containsKey('investment_amount') &&
          user.containsKey('created_at')) {
        DateTime createdAt = DateTime.parse(user['created_at']);
        if (now.difference(createdAt).inDays <= 30) {
          return sum + (user['investment_amount'] ?? 0);
        }
      }
      return sum;
    });

    // 📌 En çok yatırım alan personeli bul
    Map<String, double> personnelInvestment = {};
    for (var user in userList) {
      if (user.containsKey('assigned_to') &&
          user.containsKey('investment_amount')) {
        String personnelEmail = user['assigned_to'];
        double investment = (user['investment_amount'] ?? 0).toDouble();
        personnelInvestment[personnelEmail] =
            (personnelInvestment[personnelEmail] ?? 0) + investment;
      }
    }
    String topInvestmentPersonnel = personnelInvestment.entries.fold("",
        (max, e) => e.value > (personnelInvestment[max] ?? 0) ? e.key : max);

    // 📌 En çok müşteri ekleyen personeli bul
    Map<String, int> personnelCustomerCount = {};
    for (var user in userList) {
      if (user.containsKey('assigned_to')) {
        String personnelEmail = user['assigned_to'];
        personnelCustomerCount[personnelEmail] =
            (personnelCustomerCount[personnelEmail] ?? 0) + 1;
      }
    }
    String topCustomerAddingPersonnel = personnelCustomerCount.entries.fold("",
        (max, e) => e.value > (personnelCustomerCount[max] ?? 0) ? e.key : max);

    // 📌 Toplam çağrı süresi (dakika)
    int totalCallDuration = userList.fold(0, (sum, user) {
      return sum + ((user['call_duration'] ?? 0) as num).toInt();
    });

    // 📌 Müşteri telefon durumu istatistikleri
    Map<String, int> phoneStatusCounts = {
      "Cevapsız": 0,
      "Yanlış No": 0,
      "Meşgul": 0,
      "Onayladı": 0
    };
    for (var user in userList) {
      if (user.containsKey('phone_status')) {
        String status = user['phone_status'];
        if (phoneStatusCounts.containsKey(status)) {
          phoneStatusCounts[status] = phoneStatusCounts[status]! + 1;
        }
      }
    }

    // 📌 Admin Paneli Verileri (EKLENDİ!)
    final Map<String, dynamic> adminDashboard = {
      "total_customers": totalCustomers,
      "total_personnel": totalPersonnel,
      "last_7_days_customers": last7DaysCustomers,
      "last_30_days_investment": last30DaysInvestment,
      "top_investment_personnel": topInvestmentPersonnel,
      "top_customer_adding_personnel": topCustomerAddingPersonnel,
      "total_call_duration": totalCallDuration,
      "phone_status_counts": phoneStatusCounts,
      "personnel_details": personnelList
          .map((person) => {
                "name": person["name"],
                "email": person[
                    "email"], // Eğer email'i göstermek istemiyorsan kaldır
                "assigned_customers": person["assigned_customers"] ?? [],
                "total_investment": person["total_investment"] ?? 0,
                "created_at": person["created_at"],
              })
          .toList(),
      "customer_details": userList
          .map((user) => {
                "name": user["name"],
                "email": user["email"],
                "created_at": user["created_at"],
              })
          .toList(),
      "logs": File('logs.txt').existsSync()
          ? File('logs.txt').readAsLinesSync()
          : [],
    };

    return Response.ok(jsonEncode(adminDashboard),
        headers: {'Content-Type': 'application/json'});
  });

  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware)
      .addHandler(router.call);

  var server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('✅ Server running on http://${server.address.host}:${server.port}');
}

// 🌍 CORS Middleware
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

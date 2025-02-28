// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, implicit_call_tearoffs, unused_local_variable, prefer_conditional_assignment

import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:dotenv/dotenv.dart';
import 'package:crypto/crypto.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:uuid/uuid.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:collection';
import 'dart:async';
import 'dart:math';

final Map<String, List<DateTime>> _requestLogs = HashMap();
const int maxRequests = 10;
const Duration timeFrame = Duration(minutes: 1);

final Map<String, List<DateTime>> _formRequestLogs = HashMap();

// 🔹 Eski logları düzenli olarak temizleyen Timer
void _cleanOldRequests() {
  final now = DateTime.now();
  _requestLogs.forEach((ip, timestamps) {
    timestamps
        .removeWhere((timestamp) => now.difference(timestamp) > timeFrame);
  });
}

// 🔹 Rate Limiter Middleware (Geliştirilmiş)
Middleware rateLimiter() {
  Timer.periodic(Duration(minutes: 5), (timer) {
    try {
      _cleanOldRequests();
    } catch (e) {
      print("Rate Limiter Hatası: $e"); // 🔥 Olası hataları yakala ve logla
    }
  });

  return (Handler innerHandler) {
    return (Request request) async {
      // 🔹 IP Adresini Daha Güvenli Bir Şekilde Al
      final String ip = request.headers['x-forwarded-for'] ??
          request.context['remote_ip']?.toString() ??
          (request.context['shelf.io.connection_info'] as HttpConnectionInfo?)
              ?.remoteAddress
              .address ??
          'unknown';

      final now = DateTime.now();
      _requestLogs.putIfAbsent(ip, () => []);

      // 🔹 Eski istekleri temizle
      _requestLogs[ip]!
          .removeWhere((timestamp) => now.difference(timestamp) > timeFrame);

      if (_requestLogs[ip]!.length >= maxRequests) {
        return Response(
          429,
          body: jsonEncode(
              {"error": "Çok fazla istek attınız. Lütfen bir süre bekleyin!"}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      _requestLogs[ip]!.add(now);
      return innerHandler(request);
    };
  };
}

final String serverSecret =
    Uuid().v4(); // Her sunucu başlatıldığında farklı olur!

JwtClaim? verifyAndDecodeJWTWithServerSecret(String token) {
  try {
    final JwtClaim claimSet = verifyJwtHS256Signature(token, secretKey);
    claimSet.validate(issuer: 'crm_server');

    // 📌 Token önceki sunucu başlatılmasında oluşturulmuşsa geçersiz yap!
    if (claimSet.toJson()['server_secret'] != serverSecret) {
      return null;
    }

    return claimSet;
  } catch (e) {
    print("JWT doğrulama hatası: $e");
    return null;
  }
}

final env = DotEnv()..load();

// 🔌 MongoDB bağlantısı
final String dbUri = env['MONGODB_URI'] ?? '';
final mongo.Db db = mongo.Db(dbUri);
late final mongo.DbCollection customersCollection;
late final mongo.DbCollection personnelCollection;
late final mongo.DbCollection companiesCollection;
late final mongo.DbCollection adminCollection;
late final mongo.DbCollection
    advertisementsCollection; // 🔹 Yeni: Reklam koleksiyonu

// 🔑 JWT Token için gizli anahtar
final String secretKey = env['JWT_SECRET'] ?? '';

Future<void> initializeDatabase() async {
  if (!db.isConnected) {
    await db.open();
  }

  // Koleksiyonların başlatılması
  customersCollection = db.collection('customers');
  adminCollection = db.collection('admin');
  personnelCollection = db.collection('personnel');
  companiesCollection = db.collection('companies');
  advertisementsCollection =
      db.collection('advertisements'); // 🔹 Yeni: Reklam koleksiyonu
}

// 🎫 JWT Token oluşturma
String generateJWT(String email, String role, String userId) {
  final claimSet = JwtClaim(
    issuer: 'crm_server',
    subject: email,
    otherClaims: {'role': role, 'user_id': userId},
    issuedAt: DateTime.now(),
    expiry:
        DateTime.now().add(Duration(minutes: 30)), // 📌 Token 30 dakika geçerli
  );
  return issueJwtHS256(claimSet, secretKey);
}

// 🔍 JWT Token doğrulama
JwtClaim? verifyAndDecodeJWT(String token) {
  try {
    final JwtClaim claimSet = verifyJwtHS256Signature(token, secretKey);
    claimSet.validate(issuer: 'crm_server');
    return claimSet;
  } catch (e) {
    print("JWT doğrulama hatası: $e");
    return null;
  }
}

// 📌 Yetkilendirme Middleware
Middleware checkAuth({bool isAdminRequired = false}) {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['Authorization'];

      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response(401, body: jsonEncode({"error": "Yetkisiz erişim"}));
      }

      final token = authHeader.substring(7);
      try {
        final claimSet = verifyJwtHS256Signature(token, secretKey);
        claimSet.validate(issuer: 'crm_server');

        request = request.change(context: {'jwt': claimSet});

        if (isAdminRequired && claimSet['role'] != 'admin') {
          return Response(403,
              body: jsonEncode({"error": "Admin yetkisi gerekli!"}));
        }

        return innerHandler(request);
      } catch (e) {
        return Response(401, body: jsonEncode({"error": "Geçersiz token"}));
      }
    };
  };
}

Future<void> main() async {
  await initializeDatabase();
  final router = Router();

  // 📌 **Admin Girişi**
  router.post('/api/v2/auth/admin-login', (Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      // 🔹 NULL veya BOŞ veri kontrolü
      if (data['email'] == null ||
          data['email'].isEmpty ||
          data['password'] == null ||
          data['password'].isEmpty) {
        return Response(
          400,
          body: jsonEncode({"error": "E-posta ve şifre boş olamaz!"}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // 🔹 Admin kullanıcıyı veritabanında ara
      final admin = await adminCollection.findOne({'email': data['email']});

      if (admin == null) {
        return Response(
          401,
          body: jsonEncode({"error": "Geçersiz giriş"}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // 🔹 Eğer salt veya password NULL ise, giriş başarısız olur
      if (admin['salt'] == null || admin['password'] == null) {
        return Response(
          401,
          body: jsonEncode({"error": "Geçersiz giriş"}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // 🔹 SHA-512 ile şifreyi hashleyerek kontrol et
      final hashedPassword =
          hashPassword(data['password'], admin['salt'] ?? '');

      if (admin['password'] != hashedPassword) {
        return Response(
          401,
          body: jsonEncode({"error": "Geçersiz giriş"}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // 🔹 JWT Token oluştur
      final token =
          generateJWT(data['email'], 'admin', admin['_id'].toString());

      return Response.ok(
        jsonEncode({"token": token}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, stackTrace) {
      print("Admin Login Error: $e\n$stackTrace"); // 🔥 Hata loglanıyor

      return Response(
        500,
        body: jsonEncode({"error": "Sunucu hatası: $e"}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // 📌 **Personel Girişi**
  router.post('/api/v2/auth/login', (Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      if (!data.containsKey("email") || !data.containsKey("password")) {
        return Response(400,
            body: jsonEncode({"error": "E-posta ve şifre gerekli"}));
      }

      final user = await personnelCollection
          .findOne(mongo.where.eq("email", data["email"]));

      if (user == null) {
        return Response(401,
            body: jsonEncode({"error": "Geçersiz giriş bilgileri"}));
      }

      // 🔹 Hashlenmiş şifreyi kontrol et
      String salt = user["salt"];
      String hashedPassword = hashPassword(data["password"], salt);

      if (hashedPassword != user["password"]) {
        return Response(401,
            body: jsonEncode({"error": "Geçersiz giriş bilgileri"}));
      }

      // 🔹 JWT Token oluştur
      String token =
          generateJWT(user["email"], "personel", user["_id"].toString());

      return Response.ok(jsonEncode({"token": token, "role": "personel"}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response(500, body: jsonEncode({"error": "Sunucu hatası: $e"}));
    }
  });

  // 📌 **Admin -> Personel DB kayıt etme (salt)**
  router.post(
      '/api/v2/auth/personnel',
      checkAuth(isAdminRequired: true)((Request request) async {
        try {
          final payload = await request.readAsString();
          final data = jsonDecode(payload);

          // 🔹 Gerekli alanları kontrol et
          if (!data.containsKey("name") ||
              !data.containsKey("email") ||
              !data.containsKey("password")) {
            return Response(400,
                body: jsonEncode({"error": "Eksik personel bilgisi"}));
          }

          // 🔹 Şifreyi hashleyelim
          String salt = generateSalt();
          String hashedPassword = hashPassword(data["password"], salt);

          // 🔹 Aynı email ile kayıt varsa hata ver
          final existingPersonnel = await personnelCollection
              .findOne(mongo.where.eq("email", data["email"]));
          if (existingPersonnel != null) {
            return Response(409,
                body: jsonEncode({"error": "Bu e-posta zaten kullanılıyor!"}));
          }

          // 🔹 Personeli kaydedelim
          final result = await personnelCollection.insertOne({
            "name": data["name"],
            "email": data["email"],
            "password": hashedPassword,
            "salt": salt, // 📌 Şifreyi doğrulamak için Salt da kaydediyoruz!
            "created_at": DateTime.now(),
            "role": "personel" // 📌 Yetkilendirme için rol ekledik!
          });

          if (result.isSuccess) {
            return Response.ok(jsonEncode({
              "status": "success",
              "message": "Personel başarıyla kaydedildi"
            }));
          } else {
            return Response(500,
                body: jsonEncode({"error": "Personel kaydı başarısız"}));
          }
        } catch (e) {
          return Response(500,
              body: jsonEncode({"error": "Sunucu hatası: $e"}));
        }
      }));

  // 📌 **Admin Firma Bilgilerini Güncelleyebilir**
  router.put(
    '/api/v2/companies/<id>',
    checkAuth(isAdminRequired: true)((Request request) async {
      final String id = request.params['id']!;
      try {
        final String payload = await request.readAsString();
        final dynamic data = jsonDecode(payload);

        // 🔹 Güncellenecek firmayı kontrol et
        final Map<String, dynamic>? company = await companiesCollection
            .findOne(mongo.where.id(mongo.ObjectId.parse(id)));

        if (company == null) {
          return Response(
            404,
            body: jsonEncode({"error": "Firma bulunamadı"}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // 🔹 Güncellenecek alanları belirle
        final modifier = mongo.modify;
        data.forEach((key, value) {
          modifier.set(
              key, value); // 🔥 `setAll` yerine tek tek alanları güncelle!
        });

        // 🔹 MongoDB'de güncelleme yap
        final result = await companiesCollection.update(
            mongo.where.id(mongo.ObjectId.parse(id)), modifier);

        if (result['nModified'] > 0) {
          return Response.ok(
            jsonEncode({
              "status": "success",
              "message": "Firma başarıyla güncellendi"
            }),
            headers: {'Content-Type': 'application/json'},
          );
        } else {
          return Response(
            500,
            body: jsonEncode({"error": "Firma güncellenemedi"}),
            headers: {'Content-Type': 'application/json'},
          );
        }
      } catch (e) {
        return Response(
          500,
          body: jsonEncode({"error": "Sunucu hatası: $e"}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    }),
  );
  // 📌 **Admin Firma Bilgisini Silebilir**
  router.delete(
      '/api/v2/companies/<id>',
      checkAuth(isAdminRequired: true)((Request request) async {
        final String id = request.params['id']!;
        final result = await companiesCollection
            .remove(mongo.where.id(mongo.ObjectId.parse(id)));

        if (result['n'] > 0) {
          return Response.ok(jsonEncode(
              {"status": "success", "message": "Firma başarıyla silindi"}));
        } else {
          return Response(500, body: jsonEncode({"error": "Firma silinemedi"}));
        }
      }));

  // 📌 **Reklam Oluşturma Endpoint’i (Admin)**
  router.post(
      '/api/v2/advertisements',
      checkAuth(isAdminRequired: true)((Request request) async {
        try {
          final payload = await request.readAsString();
          final data = jsonDecode(payload);

          // Gerekli alan kontrolü: site_url, site_form_url, send_endpoint
          if (!data.containsKey("site_url") ||
              !data.containsKey("site_form_url") ||
              !data.containsKey("send_endpoint")) {
            return Response(
              400,
              body: jsonEncode({"error": "Eksik reklam bilgisi!"}),
              headers: {'Content-Type': 'application/json'},
            );
          }

          final sendEndpoint = data["send_endpoint"];
          final uri = Uri.tryParse(sendEndpoint);
          if (uri == null || uri.pathSegments.length < 3) {
            return Response(
              400,
              body: jsonEncode({"error": "Geçersiz send_endpoint formatı!"}),
              headers: {'Content-Type': 'application/json'},
            );
          }
          // Son segmenti (ref) alıyoruz:
          final ref = uri.pathSegments.last;

          // Aynı ref ile reklam varsa hata döndür
          final existingAd =
              await advertisementsCollection.findOne({"ref": ref});
          if (existingAd != null) {
            return Response(
              409,
              body: jsonEncode(
                  {"error": "Bu referansa ait reklam zaten mevcut!"}),
              headers: {'Content-Type': 'application/json'},
            );
          }

          final adData = {
            "site_url": data["site_url"],
            "site_form_url": data["site_form_url"],
            "send_endpoint": sendEndpoint,
            "ref": ref,
            "created_at": DateTime.now(),
          };

          final result = await advertisementsCollection.insertOne(adData);
          if (result.isSuccess) {
            return Response.ok(
              jsonEncode({
                "status": "success",
                "message": "Reklam başarıyla oluşturuldu!",
                "ref": ref
              }),
              headers: {'Content-Type': 'application/json'},
            );
          } else {
            return Response(
              500,
              body: jsonEncode({"error": "Reklam oluşturulamadı!"}),
              headers: {'Content-Type': 'application/json'},
            );
          }
        } catch (e) {
          return Response(
            500,
            body: jsonEncode({"error": "Sunucu hatası: $e"}),
            headers: {'Content-Type': 'application/json'},
          );
        }
      }));

  // 📌 Form Gönderme Endpoint’i (Varsayılan)
  router.post('/api/v2/form', (Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      // 📌 IP adresini çekiyoruz (Spam koruması için)
      final String ip = request.headers['x-forwarded-for'] ??
          (request.context['shelf.io.connection_info'] as HttpConnectionInfo?)
              ?.remoteAddress
              .address ??
          'unknown';

      final now = DateTime.now();
      _formRequestLogs.putIfAbsent(ip, () => []);

      // 📌 Eğer aynı IP'den 1 dakikada 3'ten fazla istek geldiyse, engelle!
      _formRequestLogs[ip]!.removeWhere(
          (timestamp) => now.difference(timestamp) > Duration(minutes: 1));
      if (_formRequestLogs[ip]!.length >= 3) {
        return Response(
          429,
          body: jsonEncode(
              {"error": "Çok fazla istek attınız. Lütfen biraz bekleyin!"}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      _formRequestLogs[ip]!.add(now);

      // 📌 Eksik alan kontrolü
      if (!data.containsKey("name") ||
          !data.containsKey("email") ||
          !data.containsKey("phone")) {
        return Response(
          400,
          body: jsonEncode({"error": "Eksik bilgi girdiniz!"}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // 📌 Aynı email ile kayıt kontrolü
      final existingCustomer = await customersCollection
          .findOne(mongo.where.eq("email", data["email"]));
      if (existingCustomer != null) {
        return Response(
          409,
          body: jsonEncode({"error": "Bu e-posta adresi zaten kayıtlı!"}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // 📌 Yeni müşteri verisi
      final newCustomer = {
        "name": data["name"],
        "email": data["email"],
        "phone": data["phone"],
        "trade_status": false,
        "investment_status": false,
        "investment_amount": 0,
        "assigned_to":
            null, // 📌 Şu an için boş, daha sonra bir personel atanacak
        "call_duration": 0,
        "phone_status": "Bilinmiyor",
        "previous_investment": false,
        "expected_investment_date": null,
        "created_at": DateTime.now().toUtc(),
      };

      // 📌 MongoDB'ye kaydet
      final result = await customersCollection.insertOne(newCustomer);

      if (result.isSuccess) {
        return Response.ok(
          jsonEncode({
            "status": "success",
            "message": "Müşteri başarıyla kaydedildi!"
          }),
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        return Response(
          500,
          body: jsonEncode({"error": "Müşteri kaydedilemedi!"}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({"error": "Sunucu hatası: $e"}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // 📌 Reklam'a Özel Form Gönderim Endpoint’i
  router.post('/api/v2/form/<ref>', (Request request) async {
    final ref = request.params['ref']!;
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      // 📌 IP adresini al (Spam kontrolü için)
      final String ip = request.headers['x-forwarded-for'] ??
          (request.context['shelf.io.connection_info'] as HttpConnectionInfo?)
              ?.remoteAddress
              .address ??
          'unknown';

      final now = DateTime.now();
      _formRequestLogs.putIfAbsent(ip, () => []);
      _formRequestLogs[ip]!.removeWhere(
          (timestamp) => now.difference(timestamp) > Duration(minutes: 1));
      if (_formRequestLogs[ip]!.length >= 3) {
        return Response(
          429,
          body: jsonEncode(
              {"error": "Çok fazla istek attınız. Lütfen biraz bekleyin!"}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      _formRequestLogs[ip]!.add(now);

      // Gerekli alan kontrolü: name, email, phone
      if (!data.containsKey("name") ||
          !data.containsKey("email") ||
          !data.containsKey("phone")) {
        return Response(
          400,
          body: jsonEncode({"error": "Eksik bilgi girdiniz!"}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // Yeni form verisini hazırla (gerekli alanlar ve reklam ref'i)
      final newSubmission = {
        "name": data["name"],
        "email": data["email"],
        "phone": data["phone"],
        "trade_status": false,
        "investment_status": false,
        "investment_amount": 0,
        "assigned_to": null,
        "call_duration": 0,
        "phone_status": "Bilinmiyor",
        "previous_investment": false,
        "expected_investment_date": null,
        "created_at": DateTime.now().toUtc(),
        "advertisement_ref": ref,
      };

      // "submissions_<ref>" adında dinamik koleksiyon kullan (koleksiyon, ilk eklemede otomatik oluşturulacaktır)
      final submissionCollection = db.collection('submissions_$ref');
      final result = await submissionCollection.insertOne(newSubmission);

      if (result.isSuccess) {
        return Response.ok(
          jsonEncode({
            "status": "success",
            "message": "Müşteri başarıyla kaydedildi!",
            "advertisement_ref": ref,
          }),
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        return Response(
          500,
          body: jsonEncode({"error": "Müşteri kaydedilemedi!"}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({"error": "Sunucu hatası: $e"}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // 📌 **Admin ve Personel Müşteri Bilgilerini Görebilir**
  router.get(
      '/api/v2/customers',
      checkAuth()((Request request) async {
        final claim = request.context['jwt'] as JwtClaim;
        final String userRole = claim.toJson()['role'];
        final String personnelEmail = claim.subject ?? '';

        List<Map<String, dynamic>> customers;

        if (userRole == 'admin') {
          // 🔹 Admin tüm müşteri bilgilerini alabilir
          customers = await customersCollection.find().toList();
        } else if (userRole == 'personel') {
          // 🔹 Personel sadece kendisine atanmış müşterileri görebilir
          customers = await customersCollection
              .find(mongo.where.eq('assigned_to', personnelEmail))
              .toList();

          // 🔹 Personelin görebileceği verileri sınırla ve telefon numarasını maskele
          customers = customers.map((customer) {
            return {
              "name": customer["name"],
              "investment_amount": customer["investment_amount"],
              "phone": maskPhoneNumber(customer["phone"]),
            };
          }).toList();
        } else {
          return Response.forbidden(jsonEncode({"error": "Yetkisiz erişim"}));
        }

        final formattedCustomers = customers.map((customer) {
          return customer.map((key, value) {
            if (value is DateTime) {
              return MapEntry(key, value.toIso8601String());
            }
            return MapEntry(key, value);
          });
        }).toList();

        return Response.ok(jsonEncode(formattedCustomers),
            headers: {'Content-Type': 'application/json'});
      }));

  // 📌 **Personel Sadece Kendi Müşterisini Görebilir**
  router.get(
      '/api/v2/customers/assigned',
      checkAuth()((Request request) async {
        final claim = request.context['jwt'] as JwtClaim;
        final String personnelEmail = claim.subject ?? '';

        final assignedCustomers = await customersCollection
            .find(mongo.where.eq('assigned_to', personnelEmail))
            .toList();

        return Response.ok(jsonEncode(assignedCustomers));
      }));

  // 📌 **Admin Müşteri Ekleyebilir ve Atayabilir**
  router.post(
      '/api/v2/customers',
      checkAuth(isAdminRequired: true)((Request request) async {
        final payload = await request.readAsString();
        final data = jsonDecode(payload);
        data['created_at'] = DateTime.now().toIso8601String();

        final result = await customersCollection.insertOne(data);
        if (result.isSuccess) {
          return Response(201, body: jsonEncode({"status": "success"}));
        } else {
          return Response(500,
              body: jsonEncode({"error": "Müşteri eklenemedi"}));
        }
      }));

  // 📌 **Personel Yalnızca Kendi Müşterisini Güncelleyebilir**
  router.put(
    '/api/v2/customers/<id>',
    checkAuth()((Request request) async {
      final claim = request.context['jwt'] as JwtClaim;
      final String personnelEmail = claim.subject ?? '';

      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      final id = request.params['id'];
      final customer = await customersCollection
          .findOne(mongo.where.id(mongo.ObjectId.parse(id!)));

      if (customer == null) {
        return Response.notFound(jsonEncode({"error": "Müşteri bulunamadı"}));
      }

      // Eğer personel ise ve müşteriyi güncellemeye yetkisi yoksa hata ver
      if (claim.toJson()['role'] == 'personel' &&
          customer['assigned_to'] != personnelEmail) {
        return Response.forbidden(
            jsonEncode({"error": "Bu müşteri sizin atanmış değil"}));
      }

      // 🔹 **MongoDB UpdateOne Kullanımı**
      final updateModifier = mongo.modify;
      data.forEach((key, value) {
        updateModifier.set(key, value);
      });

      final result = await customersCollection.updateOne(
          mongo.where.id(mongo.ObjectId.parse(id)), updateModifier);
      //
      // final result = await customersCollection.updateOne(
      //     mongo.where.id(mongo.ObjectId.parse(id)),
      //     mongo.modify.);

      if (result.isAcknowledged) {
        return Response.ok(jsonEncode({"status": "success"}));
      } else {
        return Response.internalServerError(
            body: jsonEncode({"error": "Müşteri güncellenemedi"}));
      }
    }),
  );

  // 📌 **Admin Müşteri Silebilir**
  router.delete(
    '/api/v2/customers/<id>',
    checkAuth(isAdminRequired: true)((Request request) async {
      final id = request.params['id'];
      final result = await customersCollection
          .deleteOne(mongo.where.id(mongo.ObjectId.parse(id!)));
      final handler = Pipeline()
          .addMiddleware(rateLimiter())
          .addMiddleware(logRequests())
          .addMiddleware(corsMiddleware)
          .addHandler(router);

      final server =
          await shelf_io.serve(handler, InternetAddress.anyIPv4, 80);
      if (result.isAcknowledged) {
        return Response.ok(jsonEncode({"status": "success"}));
      } else {
        return Response.internalServerError(
            body: jsonEncode({"error": "Silme işlemi başarısız"}));
      }
    }),
  );

  // 📌 **Admin Yeni Firma Ekleyebilir**
  router.post(
      '/api/v2/companies',
      checkAuth(isAdminRequired: true)((Request request) async {
        final payload = await request.readAsString();
        final data = jsonDecode(payload);

        // Gerekli alanları kontrol et
        if (!data.containsKey("name") ||
            !data.containsKey("address") ||
            !data.containsKey("phone")) {
          return Response(400,
              body: jsonEncode({"error": "Eksik firma bilgisi"}));
        }

        // Firmayı ekleyelim
        final result = await companiesCollection.insertOne({
          "name": data["name"],
          "address": data["address"],
          "phone": data["phone"],
          "created_at": DateTime.now(),
        });

        if (result.isSuccess) {
          return Response.ok(jsonEncode(
              {"status": "success", "message": "Firma başarıyla eklendi"}));
        } else {
          return Response(500, body: jsonEncode({"error": "Firma eklenemedi"}));
        }
      }));

  // 📌 **Admin Tüm Firma Bilgilerini Görebilir**
  router.get(
      '/api/v2/companies',
      checkAuth(isAdminRequired: true)((Request request) async {
        try {
          final companies = await companiesCollection.find().toList();

          // 🔹 DateTime nesnelerini JSON uyumlu
          final formattedCompanies = companies.map((company) {
            return company.map((key, value) {
              if (value is DateTime) {
                return MapEntry(key, value.toIso8601String());
              }
              return MapEntry(key, value);
            });
          }).toList();

          return Response.ok(
            jsonEncode(formattedCompanies),
            headers: {'Content-Type': 'application/json'},
          );
        } catch (e) {
          return Response(
            500,
            body: jsonEncode({"error": "Sunucu hatası: $e"}),
            headers: {'Content-Type': 'application/json'},
          );
        }
      }));

  final handler = Pipeline()
      .addMiddleware(rateLimiter())
      .addMiddleware(corsHeaders())
      .addMiddleware(corsMiddleware)
      .addHandler(router);

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 80);
  print(
      '✅ Sunucu şu serviste açık http://${server.address.host}:${server.port}');
  print('✅ MongoDB Bağlantısı Yapıldı.');
  print('📌 Hata Dahilinde IT Birimine Başvurun.');
}

// 📌 **Salt Üretme Fonksiyonu**
String generateSalt([int length = 16]) {
  final rand = Random.secure();
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
      .join();
}

String hashPassword(String password, String salt) {
  final bytes = utf8.encode(password + salt);
  final digest = sha512.convert(bytes); // 📌 SHA-512 Kullanılıyor
  return digest.toString();
}

// 📌 Telefon numarasını maskeleme fonksiyonu
String maskPhoneNumber(String phone) {
  if (phone.length >= 10) {
    return phone.substring(0, 3) + "-XXX-XXXX";
  }
  return "XXX-XXX-XXXX"; // Eksik numaralar için güvenli varsayılan değer
}

// 📌 **CORS Middleware**
final Middleware corsMiddleware = (Handler innerHandler) {
  return (Request request) async {
    if (request.method == 'OPTIONS') {
      return Response.ok('', headers: _corsHeaders);
    }
    final Response response = await innerHandler(request);
    return response.change(headers: {...response.headers, ..._corsHeaders});
  };
};

// 📌 **CORS Headers Tanımlandı**
const Map<String, String> _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers':
      'Origin, Content-Type, Authorization, Accept, X-Requested-With',
};

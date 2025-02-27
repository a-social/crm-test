import 'dart:async';
import 'dart:convert';

import 'package:crm_k/core/config/config.dart';
import 'package:crm_k/core/models/personel_model/personel_model.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:crm_k/core/service/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonnelManager {
  final List<PersonnelModel> _personnelList = [];

  void addPersonnel(PersonnelModel personnel) {
    _personnelList.add(personnel);
    print('Personnel added: ${personnel.name}');
  }

  void removePersonnel(int id) {
    _personnelList.removeWhere((personnel) => personnel.id == id);
    print('Personnel with ID $id removed.');
  }

  PersonnelModel? getPersonnelById(int id) {
    return _personnelList.firstWhere(
      (personnel) => personnel.id == id,
      orElse: () => throw Exception('Personnel not found'),
    );
  }

  List<PersonnelModel> getAllPersonnel() {
    return List.unmodifiable(_personnelList);
  }

  void updatePersonnel(int id, PersonnelModel updatedPersonnel) {
    for (int i = 0; i < _personnelList.length; i++) {
      if (_personnelList[i].id == id) {
        _personnelList[i] = updatedPersonnel;
        print('Personnel updated: ${updatedPersonnel.name}');
        return;
      }
    }
    print('Personnel with ID $id not found.');
  }

  //piechart için
  Future<List<User>> loadUsers() async {
    final String response = await rootBundle.loadString('assets/users.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => User.fromJson(json)).toList();
  }

  Future<Map<String, int>> getPhoneStatusCounts() async {
    List<User> users = await loadUsers();
    Map<String, int> statusCounts = {};

    for (var user in users) {
      if (user.phoneStatus != null) {
        statusCounts[user.phoneStatus!] =
            (statusCounts[user.phoneStatus!] ?? 0) + 1;
      }
    }
    return statusCounts;
  }

  Future<void> callCustomer(String phoneNumber) async {
    final Uri callUri = Uri(scheme: "tel", path: phoneNumber);

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw "Arama başlatılamadı: $phoneNumber";
    }
  }

  void addNotes(String note) {
    print('not eklendi $note');
  }

  void sendWhatsappMessage(String message) {
    print('mesaj gönderildi $message');
  }

  Future<void> sendEmail(String emailData) async {
    // Gelen stringi parçala
    List<String> parts = emailData.split('|');

    if (parts.length < 3) {
      throw "Geçersiz format! Lütfen 'mail|konu|içerik' şeklinde gönderin.";
    }

    String email = parts[0].trim();
    String subject = Uri.encodeComponent(parts[1].trim());
    String body = Uri.encodeComponent(parts[2].trim());

    // Gmail URL'sini oluştur
    final String emailUrl =
        "https://mail.google.com/mail/?view=cm&fs=1&to=$email&su=$subject&body=$body";

    if (await canLaunchUrl(Uri.parse(emailUrl))) {
      await launchUrl(Uri.parse(emailUrl),
          mode: LaunchMode.externalApplication);
    } else {
      throw "Gmail açılamadı!";
    }
  }

  void addBlockList() {
    print('Kullanıcı Askıya Alındı');
  }

  void planningMeeting(DateTime time) {
    print('$time için randevu oluşturuldu');
  }
}

class PersonelMainManager {
  ///main olarak bunu kullanacağız sonradan ismini PersonelManager olarak ekleyeceğiz
  final Dio _dio;
  final StreamController<List<User>> _usersStreamController =
      StreamController.broadcast();

  PersonelMainManager({String? token})
      : _dio = Dio(BaseOptions(
          baseUrl: Config.baseUrl,
          headers: {
            'Authorization':
                token != null && token.isNotEmpty ? 'Bearer $token' : '',
            'Content-Type': 'application/json',
          },
        ));
  Future<String?> loginPersonnel(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final String token = response.data["token"];

        if (token.isNotEmpty) {
          // ✅ Token'ı geri döndür
          return token;
        }
      }
    } catch (e) {
      print("Personel giriş hatası: $e");
    }
    return null;
  }

  /// 📌 **Yatırım Miktarını Güncelleme (Mevcut Değerin Üzerine Ekleme)**
  Future<bool> updateInvestmentAmount(
      BuildContext context, String customerId, double additionalAmount) async {
    final String? token =
        Provider.of<AuthProvider>(context, listen: false).token;

    if (token == null) {
      throw Exception("Yetkisiz işlem: Token bulunamadı!");
    }

    // **Token içinden rol kontrolü**
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    if (decodedToken["role"] != "personel") {
      throw Exception(
          "Yetkisiz işlem: Sadece personeller yatırım güncelleyebilir!");
    }

    try {
      // **Önce mevcut müşteri verisini çekelim**
      final response = await _dio.get('/customers/$customerId');

      if (response.statusCode == 200) {
        Map<String, dynamic> customerData = response.data;

        double currentInvestment =
            (customerData["investment_amount"] ?? 0).toDouble();
        double updatedInvestment =
            currentInvestment + additionalAmount; // ✅ Yeni miktarı ekliyoruz

        // **Güncelleme isteği atıyoruz**
        final updateResponse = await _dio.put('/customers/$customerId', data: {
          "investment_amount": updatedInvestment,
        });

        return updateResponse.statusCode == 200;
      } else {
        throw Exception("Müşteri verisi alınamadı: ${response.statusCode}");
      }
    } catch (e) {
      print("Yatırım güncelleme hatası: $e");
      return false;
    }
  }

  /// 📌 **Atanmış Müşterileri Stream ile Güncelleyerek Getirir**
  Stream<List<User>> get assignedCustomersStream =>
      _usersStreamController.stream;

  /// 📌 **API'yi her 5 saniyede bir kontrol eder ve yeni veriyi stream'e gönderir**
  void startFetchingAssignedCustomers(BuildContext context) {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final newUsers = await fetchAssignedCustomers(context);
        _usersStreamController.add(newUsers);
      } catch (e) {
        print("Stream Güncelleme Hatası: $e");
      }
    });
  }

  /// 📌 **API'den Atanmış Müşterileri Çeker**
  Future<List<User>> fetchAssignedCustomers(BuildContext context) async {
    final String? token =
        Provider.of<AuthProvider>(context, listen: false).token;

    if (token == null) {
      throw Exception("Yetkisiz işlem: Token bulunamadı!");
    }

    try {
      final response = await _dio.get('/customers/assigned');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.data);
        return jsonData.map<User>((user) => User.fromJson(user)).toList();
      } else {
        throw Exception(
            "Atanmış müşteriler yüklenemedi: ${response.statusCode}");
      }
    } catch (e) {
      print("Hata oluştu: $e");
      throw Exception("API'den veri alınamadı!");
    }
  }

  /// 📌 **Stream'i Temizleme (Bellek Sızıntısını Önlemek İçin)**
  void dispose() {
    _usersStreamController.close();
  }

  /// Yeni personel ekleme
  Future<bool> addPersonnel({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    try {
      final response = await _dio.post('/auth/personnel', data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'role': role,
      });

      return response.statusCode == 201;
    } catch (e) {
      print('Personel eklenirken hata oluştu: $e');
      return false;
    }
  }
}

class PersonelMainManagerLocal {
  ///Send Whatsapp Message with urllaunc
  void sendWhatsAppMessage(String phoneNumber) async {
    String url = "https://web.whatsapp.com/send?phone=$phoneNumber";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print("WhatsApp Web açılamadı.");
    }
  }

  ///Call Customer with default call service microSIP skype microsoft virtual phone vs vs
  Future<void> callCustomer(String phoneNumber) async {
    final Uri callUri = Uri(scheme: "tel", path: phoneNumber);

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw "Arama başlatılamadı: $phoneNumber";
    }
  }

  ///send mail with launch url
  Future<void> sendEmail(String emailData) async {
    List<String> parts = emailData.split('|');

    if (parts.length < 3) {
      throw "Geçersiz format! Lütfen 'mail|konu|içerik' şeklinde gönderin.";
    }

    String email = parts[0].trim();
    String subject = Uri.encodeComponent(parts[1].trim());
    String body = Uri.encodeComponent(parts[2].trim());

    // Gmail URL'sini oluştur
    final String emailUrl =
        "https://mail.google.com/mail/?view=cm&fs=1&to=$email&su=$subject&body=$body";

    if (await canLaunchUrl(Uri.parse(emailUrl))) {
      await launchUrl(Uri.parse(emailUrl),
          mode: LaunchMode.externalApplication);
    } else {
      throw "Gmail açılamadı!";
    }
  }
}

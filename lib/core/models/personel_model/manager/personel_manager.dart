import 'dart:convert';

import 'package:crm_k/core/config/config.dart';
import 'package:crm_k/core/models/personel_model/personel_model.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:crm_k/core/service/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<List<User>> fetchAssignedCustomers(BuildContext context) async {
    final String? token =
        Provider.of<AuthProvider>(context, listen: false).token;

    if (token == null) {
      throw Exception("Yetkisiz işlem: Token bulunamadı!");
    }

    try {
      final response = await _dio.get('/customers/assigned');

      if (response.statusCode == 200) {
        // 🔥 **Dönen veriyi önce JSON olarak parse ediyoruz**
        final List<dynamic> jsonData = jsonDecode(response.data);
        print(jsonData);

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

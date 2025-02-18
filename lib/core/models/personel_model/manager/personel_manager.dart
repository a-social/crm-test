import 'dart:convert';

import 'package:crm_k/core/models/personel_model/personel_model.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:flutter/services.dart';
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

class PersonelTestManager {
  static Future<List<PersonnelModel>> fetchUsersFromJson() async {
    try {
      String jsonString = await rootBundle.loadString('assets/personnel.json');
      List<dynamic> jsonData = json.decode(jsonString);

      return jsonData
          .where((user) => user['email'] != null && user['name'] != null)
          .map<PersonnelModel>((user) => PersonnelModel.fromJson(user))
          .toList();
    } catch (e) {
      throw Exception("JSON verisi yüklenirken hata oluştu: $e");
    }
  }
}

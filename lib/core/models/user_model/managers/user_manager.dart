import 'dart:convert';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class UserManager {
  static const String apiBase = "http://localhost:8080/admin";

  /// Kullanıcıları API’den çeker.
  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse("$apiBase/users"));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map<User>((user) => User.fromJson(user)).toList();
    } else {
      throw Exception("Veri alınamadı: ${response.statusCode}");
    }
  }

  /// JSON dosyasından kullanıcıları çeker.
  static Future<List<User>> fetchUsersFromJson() async {
    try {
      String jsonString = await rootBundle.loadString('assets/personnel.json');
      List<dynamic> jsonData = json.decode(jsonString);

      return jsonData.map<User>((user) => User.fromJson(user)).toList();
    } catch (e) {
      throw Exception("JSON verisi yüklenirken hata oluştu: $e");
    }
  }

  /// Kullanıcı ekler.
  static Future<void> addUser(String name, String email) async {
    final response = await http.post(
      Uri.parse("$apiBase/add-user"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email}),
    );

    if (response.statusCode != 200) {
      throw Exception("Kullanıcı eklenemedi: ${response.statusCode}");
    }
  }

  /// Kullanıcıyı siler.
  static Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse("$apiBase/delete-user/$id"));

    if (response.statusCode != 200) {
      throw Exception("Kullanıcı silinemedi: ${response.statusCode}");
    }
  }
}

class UserManagerTest {
  static const String apiBase = "https://reqres.in";

  /// ReqRes API’den kullanıcıları çeker.
  static Future<List<User>> fetchUsersFromApi() async {
    final response = await http.get(Uri.parse("$apiBase/api/users?page=2"));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body)['data'];

      // Null değerleri filtrele
      return jsonData
          .where((user) => user['email'] != null && user['first_name'] != null)
          .map<User>((user) => User.fromJson(user))
          .toList();
    } else {
      throw Exception("API'den veri alınamadı: ${response.statusCode}");
    }
  }

  /// JSON dosyasından kullanıcıları çeker.
  static Future<List<User>> fetchUsersFromJson() async {
    try {
      String jsonString = await rootBundle.loadString('assets/users.json');
      List<dynamic> jsonData = json.decode(jsonString);

      return jsonData
          .where((user) => user['email'] != null && user['name'] != null)
          .map<User>((user) => User.fromJson(user))
          .toList();
    } catch (e) {
      throw Exception("JSON verisi yüklenirken hata oluştu: $e");
    }
  }
}

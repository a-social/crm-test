import 'dart:convert';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:crm_k/core/service/admin_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserManager with ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:8080"));

  /// **Kullanıcı Silme İşlemi**
  Future<void> deleteUser(String email, BuildContext context) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final token = adminProvider.token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yetkisiz işlem: Token bulunamadı!")),
      );
      return;
    }

    try {
      Response response = await _dio.delete(
        "/delete-user/$email",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      debugPrint('------------$token');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Kullanıcı başarıyla silindi!")),
        );
        notifyListeners();
      } else {
        throw Exception("Silme işlemi başarısız: ${response.data}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠ Hata oluştu: $e")),
      );
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

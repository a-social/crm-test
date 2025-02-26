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

  Future<void> updateUser(User user) async {
    try {
      Response response = await _dio.put(
        "/update-user/${user.email}",
        data: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception(
            "Kullanıcı güncellenirken hata oluştu: ${response.data}");
      }
    } catch (e) {
      throw Exception("İstek sırasında hata oluştu: $e");
    }
  }

  String blockUser(User user) {
    print(
        '${user.name} phone_status changed to BLOCKED api bağlantısı daha yapılmadı');
    return '${user.name} phone_status changed to BLOCKED api bağlantısı daha yapılmadı';
  }
}

class UserManagerTest {
  static const String apiBase = "http://localhost:8080";

  /// ReqRes API’den kullanıcıları çeker.
  /// 📌 **Tüm Kullanıcıları API'den Çekme (Provider ile Token Kullanıyor)**
  static Future<List<User>> fetchUsersFromApi(BuildContext context) async {
    final String? token =
        Provider.of<AdminProvider>(context, listen: false).token;

    if (token == null) {
      throw Exception("Yetkisiz işlem: Token bulunamadı!");
    }

    final response = await http.get(
      Uri.parse("$apiBase/users"),
      headers: {
        "Authorization": "Bearer $token", // ✅ Token direkt Provider'dan çekildi
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map<User>((user) => User.fromJson(user)).toList();
    } else if (response.statusCode == 403) {
      throw Exception("Yetkisiz işlem: Admin yetkisi gerekli!");
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

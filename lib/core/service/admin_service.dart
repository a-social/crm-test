import 'dart:convert';
import 'package:crm_k/core/config/config.dart';
import 'package:crm_k/core/models/admin_model/admin_model.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AdminProvider extends ChangeNotifier {
  AdminModel? _admin;
  String? _token; // 📌 Token saklama

  AdminModel? get admin => _admin;
  String? get token => _token; // 📌 Token erişimi

  /// **Token'ı Güncelle**
  void setToken(String newToken) {
    _token = newToken;
    notifyListeners();
  }

  /// **Admin Verisini Al**
  Future<void> fetchAdmin(String email) async {
    //admin nedense json dosyasından kontrol ediliyor auth servisi yok
    //bu kısmı kendi auth kısmımızı yarattık aslında bunu engellemek için
    //DÜZENLENECEK JSONLAR KALKACAK
    try {
      String jsonString = await rootBundle.loadString('assets/admin.json');
      List<dynamic> jsonData = json.decode(jsonString);

      var foundAdmin = jsonData.firstWhere(
        (admin) => admin['email'] == email,
        orElse: () => null,
      );

      if (foundAdmin != null) {
        _admin = AdminModel.fromJson(foundAdmin);
        notifyListeners();
      } else {
        _admin = null;
      }
    } catch (e) {
      print("Admin verisi yüklenirken hata oluştu: $e");
    }
  }
}

class AdminService with ChangeNotifier {
  late Dio _dio;

  /// **Token'ı Güncelleyen Metot**
  void updateToken(String token) {
    _dio = Dio(BaseOptions(
      baseUrl: Config.baseUrl,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // 🔹 Token'ı güncelledik
      },
    ));
  }

  /// **Kullanıcı Ekleme API Çağrısı**
  Future<void> addUser(User user, BuildContext context) async {
    final token = Provider.of<AdminProvider>(context, listen: false).token;
    if (token == null) throw Exception("Yetkisiz işlem: Token bulunamadı!");

    updateToken(token); // 📌 Token'ı güncelle

    try {
      Response response = await _dio.post(
        "/customers",
        data: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception("Kullanıcı eklenirken hata oluştu: ${response.data}");
      }
    } catch (e) {
      throw Exception("İstek sırasında hata oluştu: $e");
    }
  }
}

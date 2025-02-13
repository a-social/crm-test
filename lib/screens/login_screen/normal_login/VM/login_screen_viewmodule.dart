import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  String? errorMessage;
  String? token;
  String? userEmail;

  // 🔑 GİRİŞ İŞLEMİ
  Future<bool> loginPersonnel(String email, String password) async {
    final url = Uri.parse("http://localhost:8080/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        token = data["token"];

        if (token != null) {
          // 🔍 Token'ı çözerek email'i al
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
          userEmail = decodedToken["sub"]; // 📌 Kullanıcı emaili

          // ✅ Token'ı local storage'a kaydet
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", token!);

          errorMessage = null;
          notifyListeners();
          return true;
        }
      } else if (response.statusCode == 403) {
        errorMessage = "Geçersiz email veya şifre!";
      } else {
        errorMessage = "Sunucu hatası: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "Bağlantı hatası: $e";
    }

    notifyListeners();
    return false;
  }

  // ✅ **GİRİŞ YAPMIŞ MI KONTROL ET**
  Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");

    if (token != null && !JwtDecoder.isExpired(token!)) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      userEmail = decodedToken["sub"];
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  // 🔑 **ÇIKIŞ YAP**
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token"); // ✅ Token'ı sil
    token = null;
    userEmail = null;
    notifyListeners();
  }
}

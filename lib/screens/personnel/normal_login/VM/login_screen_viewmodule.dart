import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:hive/hive.dart';

class LoginViewModel extends ChangeNotifier {
  String? errorMessage;
  String? token;
  String? userEmail;

  // 🔑 **GİRİŞ İŞLEMİ**
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
          // 🔍 **Token'ı çözerek email'i al**
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
          userEmail = decodedToken["sub"]; // 📌 Kullanıcı emaili

          // ✅ **Token'ı Hive'a kaydet**
          var box = await Hive.openBox("authBox");

          await box.put("token", token);
          await box.put("userEmail", userEmail);

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
}

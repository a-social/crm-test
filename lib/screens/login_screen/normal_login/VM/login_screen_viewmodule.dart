import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String? errorMessage; // Hata mesajı

  Future<bool> checkMailAndPassword(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Fake API çağrısı simülasyonu

    if (email == "test@mail.com" && password == "123456") {
      errorMessage = null; // Hata yok
      return true;
    } else {
      errorMessage = "Kullanıcı adı veya şifre yanlış"; // Hata mesajı ayarla
      notifyListeners(); // UI'yı güncelle
      return false;
    }
  }
}

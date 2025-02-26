import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool _isPersonnel = false;

  String? get token => _token;
  bool get isPersonnel => _isPersonnel;

  /// 📌 Token kaydetme (Giriş yapıldığında çağrılacak)
  void saveToken(String newToken) {
    _token = newToken;
    _decodeRole(); // Token içindeki role'ü kontrol et
    notifyListeners();
  }

  /// 📌 Token'ı sıfırlama (Çıkış yapıldığında çağrılacak)
  void logout() {
    _token = null;
    _isPersonnel = false;
    notifyListeners();
  }

  /// 📌 Token içindeki `role` değerini kontrol ederek personel olup olmadığını belirler
  void _decodeRole() {
    if (_token != null && _token!.isNotEmpty) {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(_token!);
        _isPersonnel = decodedToken["role"] == "personel";
        print("-------------------------------------------------");
        print(decodedToken);
      } catch (e) {
        print("Token çözümlenirken hata oluştu: $e");
        _isPersonnel = false;
      }
    } else {
      _isPersonnel = false;
    }
  }
}

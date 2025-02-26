import 'package:dio/dio.dart';
import 'package:crm_k/core/config/config.dart';

class LoginService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Config.baseUrl,
    headers: {'Content-Type': 'application/json'},
  ));

  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return response.data["token"];
      }
    } catch (e) {
      print("Giriş hatası: $e");
    }
    return null;
  }
}

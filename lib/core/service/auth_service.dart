import 'package:crm_k/core/config/config.dart';
import 'package:dio/dio.dart';
//silinecek

class AuthAdminService {
  final Dio _dio = Dio(BaseOptions(baseUrl: Config.baseUrl));

  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/admin-login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return response.data['token']; // Token döndür
      }
    } catch (e) {
      print('Login failed: $e');
    }
    return null;
  }
}

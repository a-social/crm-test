import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));

  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post('/admin-login', data: {
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

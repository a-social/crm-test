import 'package:dio/dio.dart';

class AdminService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));

  Future<Map<String, dynamic>?> getAdminDashboard(String token) async {
    try {
      final response = await _dio.get(
        '/admin',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data; // Admin verisini döndür
      }
    } catch (e) {
      print('Failed to fetch admin data: $e');
    }
    return null;
  }
}

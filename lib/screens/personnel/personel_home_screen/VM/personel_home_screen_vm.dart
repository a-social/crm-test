import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://reqres.in/api/users?page=2";

  static Future<List<dynamic>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["data"]; // Kullanıcı verilerini döndür
      } else {
        throw Exception("Veri alınırken hata oluştu: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Bağlantı hatası: $e");
    }
  }
}

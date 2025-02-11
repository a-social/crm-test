import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceTest {
  static const String apiUrl = "http://localhost:3000/customers";

  static Future<List<dynamic>> fetchCustomers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Veri alınırken hata oluştu: ${response.statusCode}");
    }
  }
}

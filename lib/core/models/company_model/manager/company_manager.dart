import 'package:crm_k/core/config/config.dart';
import 'package:dio/dio.dart';

class CompanyManager {
  final Dio _dio;

  CompanyManager({required String? token})
      : _dio = Dio(BaseOptions(
          baseUrl: Config.baseUrl,
          headers: {
            'Authorization':
                token != null && token.isNotEmpty ? 'Bearer $token' : '',
            'Content-Type': 'application/json',
          },
        ));

  Future<List<Map<String, dynamic>>> getCompanies() async {
    try {
      final response = await _dio.get('/companies');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print('Yetkilendirme hatası: Token geçersiz veya süresi dolmuş.');
      } else {
        print('Şirketleri çekerken hata oluştu: ${e.message}');
      }
      return [];
    }
  }

  /// Yeni firma ekleme
  Future<bool> addCompany({
    required String name,
    required String email,
    required String address,
    required String phone,
    required String website,
  }) async {
    try {
      final response = await _dio.post('/companies', data: {
        'name': name,
        'mail': email,
        'address': address,
        'phone': phone,
        'website': website,
      });

      return response.statusCode == 201;
    } catch (e) {
      print('Şirket eklenirken hata oluştu: $e');
      return false;
    }
  }

  /// Firma bilgilerini güncelleme
  Future<bool> updateCompany({
    required int id,
    required String name,
    required String email,
    required String address,
    required String phone,
    required String website,
  }) async {
    try {
      final response = await _dio.put('/companies/$id', data: {
        'name': name,
        'mail': email,
        'address': address,
        'phone': phone,
        'website': website,
      });

      return response.statusCode == 200;
    } catch (e) {
      print('Şirket güncellenirken hata oluştu: $e');
      return false;
    }
  }

  /// Firma silme
  Future<bool> deleteCompany(String id) async {
    try {
      final response = await _dio.delete('/companies/$id');
      return response.statusCode == 200;
    } catch (e) {
      print('Şirket silinirken hata oluştu: $e');
      return false;
    }
  }
}

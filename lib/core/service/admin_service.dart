import 'dart:convert';

import 'package:crm_k/core/models/admin_model/admin_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class AdminProvider extends ChangeNotifier {
  AdminModel? _admin;

  AdminModel? get admin => _admin;

  Future<void> fetchAdmin(String email) async {
    try {
      String jsonString = await rootBundle.loadString('assets/admin.json');
      List<dynamic> jsonData = json.decode(jsonString);

      var foundAdmin = jsonData.firstWhere(
        (admin) => admin['email'] == email,
        orElse: () => null,
      );

      if (foundAdmin != null) {
        _admin = AdminModel.fromJson(foundAdmin);
        notifyListeners(); // UI'yi güncelle
      } else {
        _admin = null; // Eğer admin bulunmazsa temizle
      }
    } catch (e) {
      print("Admin verisi yüklenirken hata oluştu: $e");
    }
  }
}

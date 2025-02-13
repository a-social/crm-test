import 'dart:convert';

class AdminModel {
  final String name;
  final String email;
  final String password;
  final String role;
  final DateTime createdAt;

  AdminModel({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

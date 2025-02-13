import 'dart:convert';

class PersonnelModel {
  final int id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String role;
  final List<int> assignedCustomers;
  final double totalInvestment;
  final DateTime createdAt;

  PersonnelModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
    required this.assignedCustomers,
    required this.totalInvestment,
    required this.createdAt,
  });

  factory PersonnelModel.fromJson(Map<String, dynamic> json) {
    return PersonnelModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      role: json['role'],
      assignedCustomers: List<int>.from(json['assigned_customers'] ?? []),
      totalInvestment: (json['total_investment'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
      'assigned_customers': assignedCustomers,
      'total_investment': totalInvestment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

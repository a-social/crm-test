import 'dart:convert';

class CompanyModel {
  final String id;
  final String? name;
  final String? email;
  final String? address;
  final String? phone;
  final String? website;
  final DateTime? createdAt;

  CompanyModel({
    required this.id,
    this.name,
    this.email,
    this.address,
    this.phone,
    this.website,
    this.createdAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'] ?? '',
      name: json['name'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      website: json['website'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
      'website': website,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

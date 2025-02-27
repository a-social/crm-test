class User {
  final int? id;
  final String? documentId; // '_id' alanı eklendi
  final String name;
  final String email;
  final String? phone;
  final bool? tradeStatus;
  final bool? investmentStatus;
  final int? investmentAmount;
  final String? assignedTo;
  final int? callDuration;
  final String? phoneStatus;
  final bool? previousInvestment;
  final DateTime? expectedInvestmentDate;
  final DateTime? createdAt;
  final String? password; // Bazı kayıtlarda var

  User({
    this.id,
    this.documentId, // Yeni eklenen alan
    required this.name,
    required this.email,
    this.phone,
    this.tradeStatus,
    this.investmentStatus,
    this.investmentAmount,
    this.assignedTo,
    this.callDuration,
    this.phoneStatus,
    this.previousInvestment,
    this.expectedInvestmentDate,
    this.createdAt,
    this.password,
  });

  // JSON'dan User modeline çevirme
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // Server'dan gelen ID
      documentId: json['_id'], // Yeni eklenen _id alanı
      name: json['name'] ?? 'Bilinmeyen Müşteri', // Varsayılan isim
      email: json['email'] ?? 'no-email@example.com', // Varsayılan email
      phone: json['phone'],
      tradeStatus: json['trade_status'],
      investmentStatus: json['investment_status'],
      investmentAmount: json['investment_amount'],
      assignedTo: json['assigned_to'],
      callDuration: json['call_duration'],
      phoneStatus: json['phone_status'],
      previousInvestment: json['previous_investment'],
      expectedInvestmentDate: _parseDate(json['expected_investment_date']),
      createdAt: _parseDate(json['created_at']),
      password: json['password'], // Şifre bazı kayıtlarda var
    );
  }

  // User modelini JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': documentId, // JSON'a eklenen _id alanı
      'name': name,
      'email': email,
      'phone': phone,
      'trade_status': tradeStatus,
      'investment_status': investmentStatus,
      'investment_amount': investmentAmount,
      'assigned_to': assignedTo,
      'call_duration': callDuration,
      'phone_status': phoneStatus,
      'previous_investment': previousInvestment,
      'expected_investment_date': expectedInvestmentDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'password': password,
    };
  }

  // Tarih alanlarını güvenli bir şekilde parse etme
  static DateTime? _parseDate(dynamic date) {
    if (date == null || date.toString().isEmpty) return null;
    return DateTime.tryParse(date.toString());
  }

  // **toString() Metodu** - Tüm bilgileri okunabilir şekilde döndürür
  @override
  String toString() {
    return '''
      Server ID: $id,
      Document ID: $documentId,
      İsim: $name,
      Mail: $email,
      Telefon: $phone,
      Durumu: $phoneStatus,
      Kayıt Tarihi: ${createdAt?.toIso8601String()},
    ''';
  }
}

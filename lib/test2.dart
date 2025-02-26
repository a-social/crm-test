import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:crm_k/screens/admin/auto_user_load/V/auto_user_view.dart';
import 'package:flutter/material.dart';

class Test2View extends StatefulWidget {
  const Test2View({super.key});

  @override
  _Test2ViewState createState() => _Test2ViewState();
}

class _Test2ViewState extends State<Test2View> {
  late User user;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showUserDetailDialog();
    });
  }

  void _initializeUser() {
    user = User(
      id: 200,
      name: "Emre Can",
      email: "emre.can_99@gmail.com",
      phone: "+905558935783",
      tradeStatus: false,
      investmentStatus: false,
      investmentAmount: 0,
      assignedTo: "veli@company.com",
      callDuration: 194,
      phoneStatus: "Yatırımcı",
      previousInvestment: false,
      expectedInvestmentDate: DateTime.parse("2025-08-26T15:40:41Z"),
      createdAt: DateTime.parse("2024-08-26T15:40:41Z"),
    );
  }

  void _showUserDetailDialog() {
    showDialog(
        context: context, builder: (context) => AdminFunctionLoadDatButton());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kullanıcı Detayı")),
      body: const Center(
        child: Text("Kullanıcı detayları açılıyor..."),
      ),
    );
  }
}

import 'package:crm_k/screens/admin/admin_login/V/admin_login_view.dart';
import 'package:flutter/material.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:crm_k/core/service/admin_service.dart';
import 'package:provider/provider.dart';

class UserAddViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? assignedTo;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setAssignedTo(String? value) {
    assignedTo = value;
    notifyListeners();
  }

  Future<void> addUser(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    _isLoading = true;
    notifyListeners();

    final newUser = User(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim().isNotEmpty
            ? phoneController.text.trim()
            : null,
        assignedTo: assignedTo ?? "", // API boş kabul etmiyor, "" gönderiyoruz.
        callDuration: 0,
        createdAt: DateTime.now(),
        expectedInvestmentDate: null,
        investmentAmount: 0,
        investmentStatus: false,
        password: '',
        phoneStatus: '',
        previousInvestment: false,
        tradeStatus: false);

    try {
      await Provider.of<AdminService>(context, listen: false)
          .addUser(newUser, context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Kullanıcı başarıyla eklendi!")),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AdminLogin(),
        ),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠ Hata oluştu: $e")),
      );
    }

    _isLoading = false;
    notifyListeners();
  }
}

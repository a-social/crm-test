import 'package:crm_k/core/service/admin_service.dart';
import 'package:crm_k/core/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    emailController.text = 'admin1@example.com';
    passwordController.text = 'Sqlqkqsmele-';
  }

  Future<void> login() async {
    print('Girdi');
    setState(() {
      isLoading = true;
    });

    String? token =
        await authService.login(emailController.text, passwordController.text);

    if (token != null) {
      var decodedToken = JwtDecoder.decode(token);
      final String email = decodedToken['sub'];

      // 📌 Admin bilgilerini provider'a kaydet
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      await adminProvider.fetchAdmin(email);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const APage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed, please try again.')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Container(
            width: 350,
            height: 350,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  autofocus: true,
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  autofocus: true,
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: login,
                  child: const Text('Giriş Yap'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class APage extends StatelessWidget {
  const APage({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context).admin;

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Bilgileri")),
      body: admin != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Adı: ${admin.name}", style: TextStyle(fontSize: 18)),
                  Text("Email: ${admin.email}", style: TextStyle(fontSize: 18)),
                  Text("Rolü: ${admin.role}", style: TextStyle(fontSize: 18)),
                  Text("Oluşturulma Tarihi: ${admin.createdAt}",
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : Center(child: Text("Admin bilgisi bulunamadı!")),
    );
  }
}

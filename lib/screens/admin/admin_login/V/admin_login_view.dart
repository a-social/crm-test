import 'package:crm_k/core/service/admin_service.dart';
import 'package:crm_k/core/service/auth_service.dart';
import 'package:crm_k/screens/admin/home_screen/V/home_screen_view.dart';
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
  final AuthAdminService authService = AuthAdminService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController.text = 'admin@crm.com';
    passwordController.text = 'admintest1234';
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    String? token = await authService.login(
      emailController.text,
      passwordController.text,
    );

    if (token != null) {
      var decodedToken = JwtDecoder.decode(token);
      final String email = decodedToken['sub'];
      print(email);
      print('---------');
      print(decodedToken);

      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      adminProvider.setToken(token); // 📌 Token'ı kaydet
      await adminProvider.fetchAdmin(email);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreenView(),
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
      appBar: AppBar(),
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

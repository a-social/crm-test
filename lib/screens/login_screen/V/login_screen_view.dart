import 'package:crm_k/core/functions/global_functions.dart';
import 'package:crm_k/core/icons/unit_icons.dart';
import 'package:crm_k/core/lang/unit_strings.dart';
import 'package:crm_k/core/widgets/loading_view/V/loading_indicator_project_view.dart';
import 'package:crm_k/screens/home_screen/V/home_screen_view.dart';
import 'package:crm_k/screens/login_screen/VM/login_screen_viewmodule.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // Şifre gizleme/gösterme kontrolü

  @override
  Widget build(BuildContext context) {
    final loginVM = Provider.of<LoginViewModel>(context);
    bool isLoading = false;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Container içeriği kadar olacak
                children: [
                  Text(UnitStrings.loginText,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),

                  // E-posta Alanı
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: UnitStrings.loginMail,
                      hintText: UnitStrings.loginMailHint,
                      prefixIcon: UnitIcons.loginMailIcon,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Şifre Alanı
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: UnitStrings.loginPassword,
                      hintText: UnitStrings.loginPasswordHint,
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? (Icons.visibility)
                            : (Icons.visibility_off)),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Giriş Butonu
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = !isLoading;
                      });

                      bool success = await loginVM.checkMailAndPassword(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Giriş başarılı!")),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreenView()));
                      }
                      await Future.delayed(Duration(seconds: 2));
                      print('selamlar');

                      setState(() {
                        isLoading = !isLoading;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // Butonu genişlet
                    ),
                    child: Text("Giriş Yap"),
                  ),
                  SizedBox(height: 10),

                  // Hata Mesajı (Eğer hata varsa)
                  if (loginVM.errorMessage != null)
                    Text(
                      loginVM.errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                ],
              ),
            ),
          ),
          LoadingView(loading_value: isLoading),
        ],
      ),
    );
  }
}

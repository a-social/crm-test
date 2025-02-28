import 'package:crm_k/screens/admin/admin_login/V/admin_login_view.dart';
import 'package:crm_k/screens/personnel/normal_login/V/login_screen_view.dart';
import 'package:flutter/material.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
                child: Text('Personel')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminLogin(),
                      ));
                },
                child: Text('admin')),
          ],
        ),
      ),
    );
  }
}

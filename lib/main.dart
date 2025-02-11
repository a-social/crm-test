import 'package:crm_k/core/widgets/loading_view/VM/loading_viewmodule.dart';
import 'package:crm_k/screens/home_screen/V/home_screen_view.dart';
import 'package:crm_k/screens/login_screen/VM/login_screen_viewmodule.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/heidisql.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
            HomeScreenView(), //şimdilik login ile uğraşmamak için logine attık
        // home: LoginScreen(),
      ),
    ),
  );
  await HeidiSQL.connect();

  // Müşteri ekleme
  await HeidiSQL.addCustomer(
      "Ahmet Yılmaz", "+905552223344", "ahmet@example.com");

  // Müşterileri listeleme
  await HeidiSQL.getCustomers();
}

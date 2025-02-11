import 'package:crm_k/core/widgets/loading_view/VM/loading_viewmodule.dart';
import 'package:crm_k/screens/home_screen/V/home_screen_view.dart';
import 'package:crm_k/screens/login_screen/VM/login_screen_viewmodule.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'database/mongodb.dart';

void main() async {
  runApp(const MyApp());
  await MongoDB.connect();
  await MongoDB.importFromJson("database/data/customuers.json");
  await MongoDB.getAdmins();
  await MongoDB.getCustomers();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreenView(),
      theme: ThemeData.dark(),
    );
  }
=======
import 'package:provider/provider.dart';

void main() {
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
>>>>>>> 700e1dcfd9a7e588380cfac640b9a1a38c1de586
}

import 'package:crm_k/screens/admin/add_person/VM/admin_add_person_viewmodule.dart';
import 'package:crm_k/screens/dashboard/V/right_panel/V/right_panel_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crm_k/core/widgets/loading_view/VM/loading_viewmodule.dart';
import 'package:crm_k/screens/home_screen/V/home_screen_view.dart';
import 'package:crm_k/screens/login_screen/normal_login/VM/login_screen_viewmodule.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        //lokasyonu değiştirmei unutma
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PersonnelAddViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: GlobalKey<NavigatorState>(),
        // darkTheme: ThemeData.dark(),
        theme: ThemeData(
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 30,
          ),
          scaffoldBackgroundColor: Colors.blue[100],
          appBarTheme: AppBarTheme(backgroundColor: Colors.white),
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreenView(), // Başlangıç ekranı olarak login
      ),
    );
  }
}

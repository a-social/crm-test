import 'package:crm_k/core/models/user_model/managers/user_manager.dart';
import 'package:crm_k/core/service/admin_service.dart';
import 'package:crm_k/core/service/personel_service.dart';
import 'package:crm_k/screens/404/V/404.dart';
import 'package:crm_k/screens/admin/add_person/VM/admin_add_person_viewmodule.dart';
import 'package:crm_k/screens/admin/add_user/VM/add_user_vm.dart';
import 'package:crm_k/screens/admin/dashboard/V/right_panel/V/right_panel_view.dart';
import 'package:crm_k/screens/admin/admin_login/V/admin_login_view.dart';
import 'package:crm_k/screens/personnel/normal_login/V/login_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:crm_k/core/widgets/loading_view/VM/loading_viewmodule.dart';
import 'package:crm_k/screens/admin/home_screen/V/home_screen_view.dart';
import 'package:crm_k/screens/personnel/normal_login/VM/login_screen_viewmodule.dart';

void main() {
  usePathUrlStrategy();

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
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => AdminService()),
        ChangeNotifierProvider(create: (_) => PersonnelProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserAddViewModel()),
        ChangeNotifierProvider(create: (_) => PersonnelAddViewModel()),
        ChangeNotifierProvider(create: (_) => PersonelProviderSelect()),
        ChangeNotifierProvider(create: (_) => PersonelService()),
        ChangeNotifierProvider(create: (_) => UserManager()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: GlobalKey<NavigatorState>(),
        theme: ThemeData(
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 30,
          ),
          scaffoldBackgroundColor: Colors.blue[100],
          appBarTheme: AppBarTheme(backgroundColor: Colors.white),
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login-view',
        routes: {
          // '/' : (context) => AuthChecker(),
          '/admin-login-view': (context) => const AdminLogin(),
          '/admin-dashboard': (context) => const HomeScreenView(),
          '/home': (context) => const HomeScreenView(),
          '/login-view': (context) => LoginScreen(),
          '/404': (context) => PageNotFoundScreen()
        },
      ),
    );
  }
}

// class AuthChecker extends StatefulWidget {
//   const AuthChecker({super.key});

//   @override
//   _AuthCheckerState createState() => _AuthCheckerState();
// }

// class _AuthCheckerState extends State<AuthChecker> {
//   @override
//   void initState() {
//     super.initState();
//     checkAuthentication();
//   }

//   void checkAuthentication() async {
//     final loginVM = Provider.of<LoginViewModel>(context, listen: false);
//     bool isAuthenticated = await loginVM.checkAuth();

//     if (isAuthenticated) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreenView()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: CircularProgressIndicator()), // **Yüklenme ekranı**
//     );
//   }
// }

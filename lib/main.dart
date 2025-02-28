import 'package:crm_k/core/models/user_model/managers/user_manager.dart';
import 'package:crm_k/core/service/admin_service.dart';
import 'package:crm_k/core/service/auth_provider.dart';
import 'package:crm_k/core/service/filter_service.dart';
import 'package:crm_k/core/service/login_service.dart';
import 'package:crm_k/core/service/personel_service.dart';
import 'package:crm_k/core/service/user_service.dart';
import 'package:crm_k/screens/404/V/404.dart';
import 'package:crm_k/screens/admin/add_user/VM/add_user_vm.dart';
import 'package:crm_k/screens/login_screen/homeparent_view.dart';
import 'package:crm_k/screens/personnel/personel_chat/VM/personel_chat_vm.dart';
import 'package:crm_k/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:crm_k/core/widgets/loading_view/VM/loading_viewmodule.dart';
import 'package:crm_k/screens/personnel/normal_login/VM/login_screen_viewmodule.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => AdminService()),
        ChangeNotifierProvider(create: (_) => PersonnelProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserAddViewModel()),
        ChangeNotifierProvider(create: (_) => PersonelProviderSelect()),
        ChangeNotifierProvider(create: (_) => PersonelService()),
        ChangeNotifierProvider(create: (_) => UserManager()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        //---
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(
            loginService: LoginService(),
            authProvider: Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: [Locale('tr', 'TR')],
        locale: Locale('tr', 'TR'),
        debugShowCheckedModeBanner: false,
        navigatorKey: GlobalKey<NavigatorState>(),
        theme: MaterialTheme(TextTheme.of(context)).light().copyWith(
              scaffoldBackgroundColor: ThemeData().cardColor,
            ),
        home: HomeButtons(),
        onUnknownRoute: (settings) =>
            MaterialPageRoute(builder: (context) => PageNotFoundScreen()),
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

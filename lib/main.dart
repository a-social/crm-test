import 'package:crm_k/screens/home_screen/V/home_screen_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
}

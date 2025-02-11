import 'package:crm_k/screens/home_screen/V/home_screen_view.dart';
import 'package:flutter/material.dart';
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
}

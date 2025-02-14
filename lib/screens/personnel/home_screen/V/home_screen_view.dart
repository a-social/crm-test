import 'package:crm_k/core/service/personel_service.dart';
import 'package:crm_k/core/widgets/drawer/V/drawer_view.dart';
import 'package:crm_k/core/widgets/live_clock/V/live_clock_view.dart';
import 'package:crm_k/screens/404/V/404.dart';
import 'package:crm_k/screens/personnel/personel_dashboard/V/personel_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonelHomeScreen extends StatefulWidget {
  const PersonelHomeScreen({super.key});

  @override
  _PersonelHomeScreenState createState() => _PersonelHomeScreenState();
}

class _PersonelHomeScreenState extends State<PersonelHomeScreen> {
  Widget _selectedPage = const PersonelDashBoardScreen(); // Başlangıç sayfası

  @override
  Widget build(BuildContext context) {
    final personel = Provider.of<PersonnelProvider>(context).personel;

    // Kullanıcı admin değilse, 404 sayfasına yönlendir
    if (personel == null) {
      return const PageNotFoundScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("CRM Paneli"),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 15),
              child: const LiveClock())
        ],
      ),
      drawer: DynamicDrawer(
        onMenuSelected: (Widget newPage) {
          setState(() {
            _selectedPage = newPage; // Yeni sayfa değiştirildi
          });
        },
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          // Geçiş efektleri için
          duration: const Duration(milliseconds: 300),
          child: _selectedPage, // Yalnızca body değişecek
        ),
      ),
    );
  }
}

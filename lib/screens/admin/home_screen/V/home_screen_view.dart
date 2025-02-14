import 'package:crm_k/core/service/admin_service.dart';
import 'package:crm_k/screens/404/V/404.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crm_k/core/widgets/drawer/V/drawer_view.dart';
import 'package:crm_k/core/widgets/live_clock/V/live_clock_view.dart';
import 'package:crm_k/screens/admin/dashboard/V/dashboard_view.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  _HomeScreenViewState createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  Widget _selectedPage = const DashboardScreen(); // Başlangıç sayfası

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context).admin;

    // Kullanıcı admin değilse, 404 sayfasına yönlendir
    if (admin == null) {
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

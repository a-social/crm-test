import 'package:flutter/material.dart';
import 'package:crm_k/core/widgets/drawer/V/drawer_view.dart';
import 'package:crm_k/core/widgets/live_clock/V/live_clock_view.dart';
import 'package:crm_k/screens/dashboard/V/dashboard_view.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  _HomeScreenViewState createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  Widget _selectedPage = const DashboardScreen(); // Başlangıç sayfası

  @override
  Widget build(BuildContext context) {
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

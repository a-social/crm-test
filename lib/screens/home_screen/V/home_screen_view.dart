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
  Widget _selectedPage = DashboardScreen(); // Başlangıç sayfası

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(margin: EdgeInsets.only(right: 15), child: LiveClock())
        ],
      ),
      drawer: DynamicDrawer(
        onMenuSelected: (Widget newPage) {
          setState(() {
            _selectedPage = newPage; // Yeni sayfa değiştirildi
          });
        },
      ),
      body: _selectedPage, // Sadece body değişecek
    );
  }
}

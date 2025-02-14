import 'package:crm_k/screens/admin/dashboard/V/dashboard_view.dart';
import 'package:flutter/material.dart';

class DrawerViewModel {
  static final Map<String, Map<IconData, Widget>> menuItems = {
    "Ana Sayfa": {Icons.dashboard: DashboardScreen()},
    "Personel Ekle": {Icons.dashboard: DashboardScreen()},
    "Çıkış Yap6": {Icons.logout: DashboardScreen()},
  };
}

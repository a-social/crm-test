import 'package:crm_k/screens/admin/dashboard/V/dashboard_view.dart';
import 'package:crm_k/screens/admin/home_screen/V/home2.dart';
import 'package:crm_k/screens/viewtest/view_test.dart';
import 'package:flutter/material.dart';

class RightPanelViewmodel {
  static final Map<String, Map<IconData, Widget>> menuItems = {
    "Ana Sayfa": {Icons.dashboard: DashboardScreen()},
    "Profil": {Icons.person: UserListScreen()},
    "Ayarlar": {Icons.settings: DashboardScreen()},
    "Müşteriler": {Icons.group: CustomerListScreen()},
    "Raporlar": {Icons.bar_chart: DashboardScreen()},
    "test": {Icons.call: TestView()},
    "Mesajlar": {Icons.message: DashboardScreen()},
    "Bildirimler": {Icons.notifications: DashboardScreen()},
    "Görevler": {Icons.check_circle: DashboardScreen()},
    "Takvim": {Icons.calendar_today: DashboardScreen()},
    "Dosyalar": {Icons.folder: DashboardScreen()},
    "Takım Yönetimi": {Icons.supervisor_account: DashboardScreen()},
    "Destek Merkezi": {Icons.help: DashboardScreen()},
    "Çıkış Yap": {Icons.logout: DashboardScreen()},
    "Görevler1": {Icons.check_circle: DashboardScreen()},
    "Takvim2": {Icons.calendar_today: DashboardScreen()},
    "Dosyalar3": {Icons.folder: DashboardScreen()},
    "Takım Yönetimi4": {Icons.supervisor_account: DashboardScreen()},
    "Destek Merkezi5": {Icons.help: DashboardScreen()},
    "Çıkış Yap6": {Icons.logout: DashboardScreen()},
  };
}

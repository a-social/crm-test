import 'package:crm_k/screens/dashboard/V/dashboard_view.dart';
import 'package:crm_k/screens/home_screen/V/home2.dart';
import 'package:crm_k/screens/home_screen/V/home_screen_view.dart';
import 'package:flutter/material.dart';

class DashboardViewmodule {
  static final Map<String, Map<IconData, Widget>> menuItems = {
    "Ana Sayfa": {Icons.dashboard: HomeScreenView()},
    "Profil": {Icons.person: UserListScreen()},
    "Ayarlar": {Icons.settings: DashboardScreen()},
    "Müşteriler": {Icons.group: HomeScreenView()},
    "Raporlar": {Icons.bar_chart: HomeScreenView()},
    "Çağrılar": {Icons.call: HomeScreenView()},
    "Mesajlar": {Icons.message: HomeScreenView()},
    "Bildirimler": {Icons.notifications: HomeScreenView()},
    "Görevler": {Icons.check_circle: HomeScreenView()},
    "Takvim": {Icons.calendar_today: HomeScreenView()},
    "Dosyalar": {Icons.folder: HomeScreenView()},
    "Takım Yönetimi": {Icons.supervisor_account: HomeScreenView()},
    "Destek Merkezi": {Icons.help: HomeScreenView()},
    "Çıkış Yap": {Icons.logout: HomeScreenView()},
    "Görevler1": {Icons.check_circle: HomeScreenView()},
    "Takvim2": {Icons.calendar_today: HomeScreenView()},
    "Dosyalar3": {Icons.folder: HomeScreenView()},
    "Takım Yönetimi4": {Icons.supervisor_account: HomeScreenView()},
    "Destek Merkezi5": {Icons.help: HomeScreenView()},
    "Çıkış Yap6": {Icons.logout: HomeScreenView()},
  };
}

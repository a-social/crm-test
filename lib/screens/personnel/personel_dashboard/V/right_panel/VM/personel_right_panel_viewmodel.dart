import 'package:crm_k/screens/personnel/home_screen/V/home2.dart';
import 'package:crm_k/screens/personnel/personel_dashboard/V/personel_dashboard_view.dart';
import 'package:crm_k/screens/viewtest/view_test.dart';
import 'package:flutter/material.dart';

class RightPanelViewmodel {
  static final Map<String, Map<IconData, Widget>> menuItems = {
    "Ana Sayfa": {Icons.dashboard: PersonelDashBoardScreen()},
    "Profil": {Icons.person: UserListScreen()},
    "Ayarlar": {Icons.settings: PersonelDashBoardScreen()},
    "Müşteriler": {Icons.group: CustomerListScreen()},
    "Raporlar": {Icons.bar_chart: PersonelDashBoardScreen()},
    "test": {Icons.call: TestView()},
    "Mesajlar": {Icons.message: PersonelDashBoardScreen()},
    "Bildirimler": {Icons.notifications: PersonelDashBoardScreen()},
    "Görevler": {Icons.check_circle: PersonelDashBoardScreen()},
    "Takvim": {Icons.calendar_today: PersonelDashBoardScreen()},
    "Dosyalar": {Icons.folder: PersonelDashBoardScreen()},
    "Takım Yönetimi": {Icons.supervisor_account: PersonelDashBoardScreen()},
    "Destek Merkezi": {Icons.help: PersonelDashBoardScreen()},
    "Çıkış Yap": {Icons.logout: PersonelDashBoardScreen()},
    "Görevler1": {Icons.check_circle: PersonelDashBoardScreen()},
    "Takvim2": {Icons.calendar_today: PersonelDashBoardScreen()},
    "Dosyalar3": {Icons.folder: PersonelDashBoardScreen()},
    "Takım Yönetimi4": {Icons.supervisor_account: PersonelDashBoardScreen()},
    "Destek Merkezi5": {Icons.help: PersonelDashBoardScreen()},
    "Çıkış Yap6": {Icons.logout: PersonelDashBoardScreen()},
  };
}

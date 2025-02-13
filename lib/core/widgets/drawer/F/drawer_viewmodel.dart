import 'package:crm_k/screens/admin/add_person/V/admin_add_person.dart';
import 'package:crm_k/screens/dashboard/V/dashboard_view.dart';
import 'package:crm_k/screens/dashboard/V/middle/V/middle_view.dart';
import 'package:crm_k/screens/home_screen/V/home2.dart';
import 'package:crm_k/screens/login_screen/admin_login/V/admin_login_view.dart';
import 'package:crm_k/screens/viewtest/view_test.dart';
import 'package:crm_k/test_main.dart';
import 'package:flutter/material.dart';

class DrawerViewModel {
  static final Map<String, Map<IconData, Widget>> menuItems = {
    "Ana Sayfa": {Icons.dashboard: DashboardScreen()},
    "Profil": {Icons.person: UserListScreen()},
    "Ayarlar": {Icons.settings: DashboardScreen()},
    "Müşteriler": {Icons.group: CustomerListScreen()},
    "Raporlar": {Icons.bar_chart: DashboardScreen()},
    "test": {Icons.call: TestView()},
    "test2": {Icons.call: TestAppState()},
    "list": {Icons.list: UserListScreenView()},
    "Personel Ekleme": {Icons.list: PersonnelAddScreen()},
    "adminlogin": {Icons.notifications: AdminLogin()},
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

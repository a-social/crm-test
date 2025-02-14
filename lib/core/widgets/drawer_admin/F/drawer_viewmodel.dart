import 'package:crm_k/screens/admin/add_person/V/admin_add_person.dart';
import 'package:crm_k/screens/admin/add_user/V/add_user.dart';
import 'package:crm_k/screens/admin/dashboard/V/dashboard_view.dart';
import 'package:crm_k/screens/admin/delete_user/V/delete_user.dart';
import 'package:flutter/material.dart';

class DynamicDrawerVMAdmin {
  static final Map<String, Map<IconData, Widget>> menuItems = {
    "Ana Sayfa": {Icons.dashboard: DashboardScreen()},
    "Personel Ekle": {Icons.dashboard: PersonnelAddScreen()},
    "Müşteri Ekle": {Icons.dashboard: UserAddScreen()},
    "Müşteri Sil": {Icons.dashboard: DeleteUser()},
    "Çıkış Yap6": {Icons.logout: DashboardScreen()},
  };
}

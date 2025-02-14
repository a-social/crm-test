import 'package:crm_k/screens/admin/add_person/V/admin_add_person.dart';
import 'package:crm_k/screens/admin/add_user/V/add_user.dart';
import 'package:crm_k/screens/admin/dashboard/V/dashboard_view.dart';
import 'package:crm_k/screens/admin/delete_person/V/delete_person.dart';
import 'package:crm_k/screens/admin/delete_user/V/delete_user.dart';
import 'package:flutter/material.dart';

class DynamicDrawerVMAdmin {
  static final Map<String, Map<IconData, Widget>> menuItems = {
    "Ana Sayfa": {Icons.dashboard: DashboardScreen()},
    "Personel Ekle": {Icons.dashboard: PersonnelAddScreen()},
    "Personel Düzenle(eklenecek)": {Icons.dashboard: DeletePerson()},
    "Personel Sil": {Icons.dashboard: DeletePerson()},
    "Müşteri Ekle": {Icons.person_add: UserAddScreen()},
    "Müşteri Düzenle": {Icons.co_present_outlined: DeleteUser()},
    "Müşteri Sil": {Icons.person_off: DeleteUser()},
    "Çıkış Yap6": {Icons.logout: DashboardScreen()},
  };
}

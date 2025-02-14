import 'package:crm_k/screens/admin/dashboard/V/dashboard_view.dart';

import 'package:crm_k/screens/admin/home_screen/V/home2.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerViewModel {
  static final Map<String, Map<dynamic, Widget>> menuItems = {
    "Ana Sayfa": {Icon(Icons.dashboard): DashboardScreen()},
    "Profil": {Icon(Icons.person): UserListScreen()},
    "Whatsapp": {FaIcon(FontAwesomeIcons.whatsapp): UserListScreen()},
    "İnstagram": {Icon(Icons.person): UserListScreen()},
    "Telegram": {Icon(Icons.person): UserListScreen()},
  };
}

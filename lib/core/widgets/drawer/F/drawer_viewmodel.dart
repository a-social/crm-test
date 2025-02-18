import 'package:crm_k/screens/admin/dashboard/V/dashboard_view.dart';
import 'package:crm_k/screens/personnel/personel_chat/V/personel_chat.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerViewModel {
  static final Map<String, Map<dynamic, Widget>> menuItems = {
    "Ana Sayfa": {Icon(Icons.dashboard): DashboardScreen()},
    "Profil": {Icon(Icons.person): DashboardScreen()},
    "Mesajlar": {Icon(Icons.message): PersonelChat()},
    "Whatsapp": {FaIcon(FontAwesomeIcons.whatsapp): DashboardScreen()},
    "Telegram": {Icon(Icons.person): DashboardScreen()},
  };
}

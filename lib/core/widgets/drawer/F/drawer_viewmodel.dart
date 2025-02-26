import 'package:crm_k/screens/personnel/personel_chat/V/personel_chat.dart';
import 'package:crm_k/screens/personnel/personel_dashboard/V/personel_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerViewModel {
  static final Map<String, Map<dynamic, Widget>> menuItems = {
    "Ana Sayfa": {Icon(Icons.dashboard): PersonelDashBoardScreen()},
    "Profil": {Icon(Icons.person): PersonelDashBoardScreen()},
    "Mesajlar": {Icon(Icons.message): PersonelChat()},
    "Whatsapp": {FaIcon(FontAwesomeIcons.whatsapp): PersonelDashBoardScreen()},
    "Telegram": {Icon(Icons.person): PersonelDashBoardScreen()},
  };
}

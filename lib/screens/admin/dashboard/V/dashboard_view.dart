import 'package:crm_k/screens/admin/dashboard/V/middle/V/middle_view.dart';
import 'package:crm_k/screens/admin/dashboard/V/right_panel/V/right_panel_view_for_personel.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Row(
        children: [
          // SOL SİDEBAR
          // Expanded(
          //   flex: 2,
          //   child: SizedBox.shrink(),
          // ),

          // ANA İÇERİK
          Expanded(
            flex: 8,
            child: MainContent(),
          ),

          // SAĞ PANEL
          Expanded(
            flex: 3,
            child: RightPanelPersonnelView(),
          ),
        ],
      ),
    );
  }
}

// SOL MENÜ (Sidebar)
class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("logip",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SidebarItem(icon: Icons.home, label: "Home"),
          SidebarItem(icon: Icons.work, label: "Projects"),
          SidebarItem(icon: Icons.check_box, label: "Tasks", isActive: true),
          SidebarItem(icon: Icons.people, label: "Team"),
          SidebarItem(icon: Icons.settings, label: "Settings"),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Upgrade to Pro"),
          ),
          const SizedBox(height: 10),
          SidebarItem(icon: Icons.help, label: "Help & information"),
          SidebarItem(icon: Icons.logout, label: "Log out"),
        ],
      ),
    );
  }
}

// YAN MENÜ ÖĞELERİ
class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: isActive ? Colors.blue : Colors.black54),
          const SizedBox(width: 10),
          Text(label,
              style: TextStyle(color: isActive ? Colors.blue : Colors.black54)),
        ],
      ),
    );
  }
}


// SAĞ PANEL


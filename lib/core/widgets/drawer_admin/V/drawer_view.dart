import 'package:crm_k/core/widgets/drawer_admin/F/drawer_viewmodel.dart';
import 'package:flutter/material.dart';

class DynamicDrawerAdmin extends StatelessWidget {
  final Function(Widget) onMenuSelected;

  const DynamicDrawerAdmin({super.key, required this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: DynamicDrawerVMAdmin.menuItems.entries.map((entry) {
                String title = entry.key;
                IconData icon = entry.value.keys.first;
                Widget page = entry.value.values.first;

                return ListTile(
                  leading: Icon(icon),
                  title: Text(title),
                  onTap: () {
                    Navigator.pop(context); // Drawer'ı kapat
                    onMenuSelected(page); // Yeni sayfayı yükle
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:crm_k/core/widgets/drawer/F/drawer_viewmodel.dart';
import 'package:crm_k/core/widgets/live_clock/V/live_clock_view.dart';
import 'package:flutter/material.dart';

class DynamicDrawer extends StatelessWidget {
  final Function(Widget) onMenuSelected;

  const DynamicDrawer({super.key, required this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Menü", style: TextStyle(fontSize: 24)),
                SizedBox(height: 10),
                LiveClock(), // Canlı saat widget'ı
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: DrawerViewModel.menuItems.entries.map((entry) {
                IconData icon = entry.value.keys.first;
                String title = entry.key;
                Widget page = entry.value.values.first;

                return ListTile(
                  leading: Icon(icon),
                  title: Text(title),
                  onTap: () {
                    Navigator.pop(context);
                    onMenuSelected(page);
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

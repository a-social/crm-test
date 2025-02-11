import 'package:crm_k/screens/dashboard/V/right_panel/VM/right_panel_viewmodel.dart';
import 'package:flutter/material.dart';

class RightPanel extends StatelessWidget {
  const RightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const CircleAvatar(radius: 40, backgroundColor: Colors.blue),
          const SizedBox(height: 10),
          const Text("Megan Norton",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Text("@meganorton"),
          const SizedBox(height: 10),
          const Divider(),
          const Text("Activity", style: TextStyle(fontWeight: FontWeight.bold)),
          ListTile(
              title: const Text("Floyd Miles commented"),
              subtitle: const Text("Next week we start a new project.")),
          ListTile(
              title: const Text("Guy Hawkins added a file"),
              subtitle: const Text("Homepage.fig (13.4MB)")),

          // 📌 ListView'ı Expanded içine aldık
          Expanded(
            child: ListView(
              children: RightPanelViewmodel.menuItems.entries.map((entry) {
                String title = entry.key;
                IconData icon = entry.value.keys.first;
                Widget page = entry.value.values.first;

                return ListTile(
                  leading: Icon(icon),
                  title: Text(title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => page),
                    );
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

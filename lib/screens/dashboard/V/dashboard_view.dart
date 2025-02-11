import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
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
              child: RightPanel(),
            ),
          ],
        ),
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

// ANA İÇERİK
class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Hello, Margaret",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              StatBox(title: "Finished", value: "18", subValue: "+8 tasks"),
              StatBox(title: "Tracked", value: "31h", subValue: "-6 hours"),
              StatBox(title: "Efficiency", value: "93%", subValue: "+12%"),
              StatBox(title: "Efficiency", value: "93%", subValue: "+12%"),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Performance",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(child: Container(height: 150, color: Colors.blue[100])),
              SizedBox(width: 15),
              Expanded(child: Container(height: 150, color: Colors.blue[100])),
            ],
          ), // Placeholder for graph
          const SizedBox(height: 20),
          const Text("Current Tasks",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TaskItem(
              title: "Product Review for UI8 Market",
              status: "In progress",
              hours: "4h"),
          TaskItem(
              title: "UX Research for Product", status: "On hold", hours: "8h"),
          TaskItem(
              title: "App design and development",
              status: "Done",
              hours: "32h"),
        ],
      ),
    );
  }
}

// İSTATİSTİK KUTULARI
class StatBox extends StatelessWidget {
  final String title;
  final String value;
  final String subValue;

  const StatBox(
      {super.key,
      required this.title,
      required this.value,
      required this.subValue});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(subValue, style: TextStyle(color: Colors.green[700])),
          ],
        ),
      ),
    );
  }
}

// GÖREV ÖĞELERİ
class TaskItem extends StatelessWidget {
  final String title;
  final String status;
  final String hours;

  const TaskItem(
      {super.key,
      required this.title,
      required this.status,
      required this.hours});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(status),
      trailing:
          Text(hours, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

// SAĞ PANEL
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
              title: Text("Floyd Miles commented"),
              subtitle: Text("Next week we start a new project.")),
          ListTile(
              title: Text("Guy Hawkins added a file"),
              subtitle: Text("Homepage.fig (13.4MB)")),
          ListTile(
              leading: Icon(Icons.add), title: Text('Hızlı Yeni Kayıt Aç')),
          ListTile(
              leading: Icon(Icons.add), title: Text('Hızlı Yeni Kayıt Aç')),
          ListTile(
              leading: Icon(Icons.add), title: Text('Hızlı Yeni Kayıt Aç')),
          ListTile(
              leading: Icon(Icons.add), title: Text('Hızlı Yeni Kayıt Aç')),
          ListTile(
              leading: Icon(Icons.add), title: Text('Hızlı Yeni Kayıt Aç')),
        ],
      ),
    );
  }
}

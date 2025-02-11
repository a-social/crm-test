// ANA İÇERİK
import 'package:flutter/material.dart';

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

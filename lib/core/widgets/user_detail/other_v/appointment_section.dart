import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:flutter/material.dart';

class AppointmentSection extends StatelessWidget {
  final User user;

  const AppointmentSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Randevu Belirle",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // _buildStatusButton("Cevapsız", Colors.yellow),
            // _buildStatusButton("Meşgul", Colors.blue),
            // _buildStatusButton("Yanlış No", Colors.red),
            // _buildStatusButton("Ulaşılmıyor", Colors.grey),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: "Notunuzu girin...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Temizle"),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Ekle"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusButton(String label, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(label),
    );
  }
}

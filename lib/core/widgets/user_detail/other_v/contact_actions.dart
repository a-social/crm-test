import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:flutter/material.dart';

class ContactActions extends StatelessWidget {
  //user bilgileri buraya gelince arama vs durumlar yaratılacak
  final User user;

  const ContactActions({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildContactButton(Icons.call, "Santral", Colors.blue),
        _buildContactButton(Icons.phone, "Sabit", Colors.orange),
        _buildContactButton(Icons.chat, "Whatsapp", Colors.green),
        _buildContactButton(Icons.email, "Mail", Colors.yellow.shade700),
      ],
    );
  }

  Widget _buildContactButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon, color: color),
          iconSize: 32,
        ),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';

class UserTransactionsPage extends StatelessWidget {
  final User user;

  const UserTransactionsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("📂 Evraklar", style: _sectionTitleStyle()),
          const SizedBox(height: 10),
          Text("Henüz eklenmiş bir evrak yok."),
          const SizedBox(height: 20),
          Text("📊 Finans & Hareketler", style: _sectionTitleStyle()),
          const SizedBox(height: 10),
          Text("Bu kullanıcının finans hareketleri buraya gelecek."),
        ],
      ),
    );
  }

  TextStyle _sectionTitleStyle() {
    return const TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue);
  }
}

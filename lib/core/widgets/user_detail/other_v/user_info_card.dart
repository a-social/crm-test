import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final User user;

  const UserInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("CRM No: ${user.id}"),
            Text("Durumu: ${user.phoneStatus}"),
            Text("Eklenme Tarihi: ${user.createdAt}"),
            Text(
                "beklenen işlem tarihi: ${user.expectedInvestmentDate ?? "Bilinmiyor"}"),
          ],
        ),
      ),
    );
  }
}

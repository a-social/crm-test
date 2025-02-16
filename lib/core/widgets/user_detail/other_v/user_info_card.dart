import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:crm_k/core/texts/unit_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            /// **Avatar Ortada, Diğerleri Başlangıçta**
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue,
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            /// **İsim ve Kopyalama Butonu**
            Row(
              children: [
                Text2(user.name),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: user.toString()))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Kopyalandı')));
                    });
                  },
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),

            const SizedBox(height: 6),
            Text2("CRM No: ${user.id}"),
            Text("Durumu: ${user.phoneStatus}"),
            Text("Whatsapp: Bilinmiyor"),
            Text("Eklenme Tarihi: ${user.createdAt}"),
            Text(
                "Beklenen işlem tarihi: ${user.expectedInvestmentDate ?? "Bilinmiyor"}"),
          ],
        ),
      ),
    );
  }
}

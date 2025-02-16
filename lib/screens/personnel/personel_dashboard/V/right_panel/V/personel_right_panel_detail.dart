import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:flutter/material.dart';

class PersonelUserDetailPage extends StatelessWidget {
  final User user;

  const PersonelUserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          size: 30, color: Colors.blue),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox.square(
                      dimension: 15,
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.call, size: 30, color: Colors.blue),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Center(
                child: CircleAvatar(radius: 60, backgroundColor: Colors.blue),
              ),
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildDetailTile("Telefon Numarası", user.phone ?? ''),
                    _buildDetailTile(
                        "Yatırım Tutarı", "${user.investmentAmount} ₺"),
                    _buildDetailTile("Atanan Temsilci", user.assignedTo ?? ''),
                    _buildDetailTile("Telefon Durumu", user.phoneStatus ?? ''),
                    _buildDetailTile(
                        "Son Görüşme Süresi", "${user.callDuration} dakika"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String value) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
    );
  }
}

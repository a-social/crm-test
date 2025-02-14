import 'package:crm_k/core/models/personel_model/personel_model.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  final User user;

  const UserDetailPage({super.key, required this.user});

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
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      size: 30, color: Colors.blue),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Center(
                child: Hero(
                  tag: 'profile_pic',
                  child: CircleAvatar(radius: 60, backgroundColor: Colors.blue),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    Hero(
                      tag: 'user_name',
                      child: Text(
                        user.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    Hero(
                      tag: 'user_email',
                      child: Text(
                        user.email,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
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

class PersonelDetailViewPage extends StatelessWidget {
  final PersonnelModel personnel;

  const PersonelDetailViewPage({super.key, required this.personnel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, size: 30, color: Colors.blue),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Center(
              child: Hero(
                tag: 'profile_pic_${personnel.email}',
                child: CircleAvatar(radius: 60, backgroundColor: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Hero(
                    tag: 'personnel_name_${personnel.email}',
                    child: Text(
                      personnel.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  Hero(
                    tag: 'personnel_email_${personnel.email}',
                    child: Text(
                      personnel.email,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
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
                  _buildDetailTile("Telefon Numarası", personnel.phone),
                  _buildDetailTile("Rol", personnel.role),
                  _buildDetailTile("Atanan Müşteriler",
                      personnel.assignedCustomers.length.toString()),
                  _buildDetailTile(
                      "Toplam Yatırım", "${personnel.totalInvestment} ₺"),
                  _buildDetailTile("Oluşturulma Tarihi",
                      personnel.createdAt.toString().split(" ")[0]),
                ],
              ),
            ),
          ],
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

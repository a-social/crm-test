import 'package:crm_k/core/functions/global_functions.dart';
import 'package:crm_k/core/service/user_service.dart';
import 'package:crm_k/screens/admin/dashboard/V/middle/V/middle_view.dart';
import 'package:crm_k/screens/personnel/my_customers/V/my_customers_view.dart';
import 'package:crm_k/screens/personnel/personel_dashboard/V/right_panel/V/personel_right_panel_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonelRightPanel extends StatelessWidget {
  const PersonelRightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).selectedUser;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.open_in_full,
                      size: 30, color: Colors.blue),
                  onPressed: () {
                    if (user != null) {
                      Navigator.push(
                        context,
                        ExpandPageRoute(
                            page: PersonelUserDetailPage(
                                user: user)), // 🔥 Özel animasyonla aç
                      );
                    }
                  },
                ),
                SizedBox.square(
                  dimension: 15,
                ),
                // IconButton(
                //     icon: const Icon(Icons.call, size: 30, color: Colors.blue),
                //     onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text('Arama Yapılıyor 📞🟢🟢🟢')))),
              ],
            ),
          ),
          // Center(
          //   child: Hero(
          //     tag: 'profile_pic_${user?.email}',
          //     child: CircleAvatar(radius: 40, backgroundColor: Colors.blue),
          //   ),
          // ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: StatBox(
                            title: "Havuz", value: "48", subValue: "%8")),
                    Expanded(
                        child: StatBox(
                            title: "Yeni Başvurular",
                            value: "15",
                            subValue: "+12%")),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: StatBox(
                            title: "Gerçek Müşteri",
                            value: "18",
                            subValue: "")),
                    Expanded(
                        child: StatBox(
                            title: "Benim Müşterilerim",
                            value: "186",
                            subValue: "",
                            widget: MyCustomersView())),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                Hero(
                  tag: 'user_name_${user?.email}',
                  child: Text(
                    user != null ? user.name : "Kullanıcı Seçiniz",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Hero(
                  tag: 'user_email_${user?.email}',
                  child: Text(
                    user != null ? user.email : "@example",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),

          _buildInfoTile("Yatırım Durumu", user?.investmentStatus ?? false),
          _buildInfoTile(
              "Önceki Yatırım Var mı?", user?.previousInvestment ?? false),
          //Umuta sor
          _buildInfoTile("Ticaret Durumu", user?.tradeStatus ?? false),
          _buildTextTile("Atanan Temsilci", user?.assignedTo ?? "Atama Yok"),
          _buildTextTile("Telefon Durumu", user?.phoneStatus ?? "Bilinmiyor"),
          _buildTextTile(
              "Son Görüşme Süresi", "${user?.callDuration ?? 0} dakika"),
          _buildTextTile("Yatırım Tutarı", "${user?.investmentAmount ?? 0} ₺"),
          const SizedBox(height: 10),
          Divider(),

          // Expanded(child: FastLinkView()),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, bool value) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (_) {},
      activeColor: Colors.green,
    );
  }

  Widget _buildTextTile(String title, String value) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}

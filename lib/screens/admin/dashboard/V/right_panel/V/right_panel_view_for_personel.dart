import 'package:crm_k/core/service/personel_service.dart';
import 'package:crm_k/core/widgets/fast_links/V/fast_link_view.dart';
import 'package:crm_k/screens/admin/dashboard/V/right_panel/V/right_panel_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RightPanelPersonnelView extends StatelessWidget {
  const RightPanelPersonnelView({super.key, this.isDelete = false});
  final bool isDelete;

  @override
  Widget build(BuildContext context) {
    final personnel =
        Provider.of<PersonelProviderSelect>(context).selectedPersonel;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          personnel == null
              ? SizedBox.shrink()
              : Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.open_in_full,
                        size: 30, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PersonelDetailViewPage(personnel: personnel),
                        ),
                      );
                    },
                  ),
                ),
          Center(
            child: Hero(
              tag: 'profile_pic_${personnel?.email}',
              child: CircleAvatar(radius: 40, backgroundColor: Colors.blue),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                Hero(
                  tag: 'personnel_name_${personnel?.email}',
                  child: Text(
                    personnel != null ? personnel.name : "Personel Seçiniz",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Hero(
                  tag: 'personnel_email_${personnel?.email}',
                  child: Text(
                    personnel != null ? personnel.email : "@example.com",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          _buildTextTile("Telefon", personnel?.phone ?? "Bilinmiyor"),
          _buildTextTile("Rol", personnel?.role ?? "Tanımsız"),
          _buildTextTile("Atanan Müşteriler",
              personnel?.assignedCustomers.length.toString() ?? "0"),
          _buildTextTile(
              "Toplam Yatırım", "${personnel?.totalInvestment ?? 0} ₺"),
          _buildTextTile("Oluşturulma Tarihi",
              personnel?.createdAt.toString().split(" ")[0] ?? "Bilinmiyor"),
          const SizedBox(height: 10),
          const Divider(),

          // 📌 **Silme Butonu**
          isDelete
              ? Center(
                  child: ElevatedButton(
                    onPressed: personnel != null
                        ? () => _confirmDelete(context, personnel.email)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                    ),
                    child: const Text("Personeli Sil"),
                  ),
                )
              : SizedBox.shrink(),

          const SizedBox(height: 20),

          // Flexible(child: FastLinkView()),
        ],
      ),
    );
  }

  Widget _buildTextTile(String title, String value) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }

  /// **📌 Silme Onayı için Dialog** silme durumu doğru olursa eğer
  void _confirmDelete(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Personeli Sil"),
        content:
            Text("$email adresli personeli silmek istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePersonnel(context, email);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Evet, Sil"),
          ),
        ],
      ),
    );
  }

  /// **📌 Personeli Silme İşlemi**
  void _deletePersonnel(BuildContext context, String email) async {
    try {
      await Provider.of<PersonelService>(context, listen: false)
          .deletePersonnel(context, email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Personel başarıyla silindi!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata oluştu: $e")),
      );
    }
  }
}

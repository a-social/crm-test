import 'package:crm_k/core/functions/global_functions.dart';
import 'package:crm_k/core/models/user_model/managers/user_manager.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:crm_k/screens/admin/dashboard/V/right_panel/V/right_panel_detail.dart';
import 'package:flutter/material.dart';
import 'package:crm_k/core/widgets/fast_links/V/fast_link_view.dart';
import 'package:provider/provider.dart';

class RightPanelUserView extends StatelessWidget {
  const RightPanelUserView({super.key, this.isDelete = false});
  final bool isDelete;

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
            child: IconButton(
              icon:
                  const Icon(Icons.open_in_full, size: 30, color: Colors.blue),
              onPressed: () {
                if (user != null) {
                  Navigator.push(
                    context,
                    ExpandPageRoute(page: UserDetailPage(user: user)),
                  );
                }
              },
            ),
          ),
          Center(
            child: Hero(
              tag: 'profile_pic_${user?.email}',
              child: CircleAvatar(radius: 40, backgroundColor: Colors.blue),
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
          _buildInfoTile("Ticaret Durumu", user?.tradeStatus ?? false),
          _buildTextTile("Atanan Temsilci", user?.assignedTo ?? "Atama Yok"),
          _buildTextTile("Telefon Durumu", user?.phoneStatus ?? "Bilinmiyor"),
          _buildTextTile(
              "Son Görüşme Süresi", "${user?.callDuration ?? 0} dakika"),
          _buildTextTile("Yatırım Tutarı", "${user?.investmentAmount ?? 0} ₺"),
          const SizedBox(height: 10),
          const Divider(),
          if (isDelete)
            Center(
              child: ElevatedButton(
                onPressed: () => _showDeleteConfirmation(context, user),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Kullanıcıyı Sil"),
              ),
            )
          else
            Expanded(child: FastLinkView()),
        ],
      ),
    );
  }

  /// 📌 Kullanıcı Silme Onay Ekranı
  void _showDeleteConfirmation(BuildContext context, User? user) {
    if (user == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Kullanıcı Silme Onayı"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Ad: ${user.name}"),
            Text("E-posta: ${user.email}"),
            const SizedBox(height: 10),
            const Text("Bu kullanıcıyı silmek istediğinize emin misiniz?",
                style: TextStyle(color: Colors.red)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<UserManager>(context, listen: false)
                  .deleteUser(user.email, context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Evet, Sil"),
          ),
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

//yerini değiştirmeyi unutma
class UserProvider extends ChangeNotifier {
  User? _selectedUser;

  User? get selectedUser => _selectedUser;

  void selectUser(User user) {
    _selectedUser = user;
    notifyListeners(); // Sağ panelin güncellenmesi için haber ver
  }
}

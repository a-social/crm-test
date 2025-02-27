import 'package:crm_k/core/models/personel_model/manager/personel_manager.dart';
import 'package:crm_k/core/models/user_model/managers/user_manager.dart';
import 'package:crm_k/screens/personnel/note_screen/V/note_view.dart';
import 'package:crm_k/screens/personnel/personel_dashboard/V/right_panel/V/personel_right_panel_detail.dart';
import 'package:crm_k/screens/personnel/personel_dashboard/V/right_panel/VM/right_panel_main_vm.dart';
import 'package:flutter/material.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:provider/provider.dart';

class ManagementPage extends StatefulWidget {
  final User user;

  const ManagementPage({super.key, required this.user});

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  final RightPanelMainVm rightmodel = RightPanelMainVm();
  final PersonelMainManagerLocal _managrLocal = PersonelMainManagerLocal();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// **📌 Kullanıcı Bilgileri Özet Kartı**
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _TopEditUSerInfoBar(user: widget.user),
            ),
          ),

          const SizedBox(height: 20),

          /// **📞 Kullanıcı ile İletişime Geçme**
          _buildSectionTitle("📞 İletişim Seçenekleri"),
          _buildIconWrap([
            _buildActionIcon(
              Icons.call,
              "Telefon Ara",
              Colors.blue,
              () {
                _managrLocal.callCustomer(widget.user.phone ?? '');
              },
            ),
            _buildActionIcon(
              Icons.circle,
              "WhatsApp Gönder",
              Colors.green,
              () {
                _managrLocal.sendWhatsAppMessage(widget.user.phone ?? '');
              },
            ),
            _buildActionIcon(
              Icons.email,
              "E-Posta Gönder",
              Colors.orange,
              //belki mail templadei hazırlanabilir databaase üzerinde tutulabilir ve daha rahat şekilde verilerbilir ancak fazla fikrim yok
              () {
                _managrLocal.sendEmail(
                    '${widget.user.email}|Merhaba [bulunduğu departman]|[Bulunduğu Departman] \'a Hoşgeldiniz Size Nasıl Yardımcı Olabilirim');
              },
            ),
            // _buildActionIcon(Icons.chat, "Mesaj Gönder", Colors.teal),
          ]),

          /// **💰 Finansal İşlemler**
          _buildSectionTitle("💰 Finansal İşlemler"),
          _buildIconWrap([
            _buildActionIcon(
              Icons.account_balance_wallet,
              "Hesap Aç",
              Colors.blue,
              () {
                _managrLocal.showAccountSelectionDialog(context);
              },
            ),
            _buildActionIcon(
              Icons.attach_money,
              "Yatırım Ekle",
              Colors.green,
              () {
                //doc id almamız gerek
                rightmodel.addInvestmentAmount(
                    context,
                    widget.user.documentId.toString(),
                    (widget.user.investmentAmount ?? 0.0).toDouble());
              },
            ),
            _buildActionIcon(
              Icons.history,
              "İşlem Geçmişi",
              Colors.orange,
              () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonelUserDetailPage(
                        user: widget.user,
                        index: 1,
                      ),
                    ));
              },
            ),
          ]),

          /// **⚙️ Kullanıcı Yönetimi**
          _buildSectionTitle("⚙️ Kullanıcı Yönetimi"),
          _buildIconWrap([
            _buildActionIcon(
              Icons.assignment_ind,
              "Temsilci Değiştir",
              Colors.purple,
              () {},
            ),
            _buildActionIcon(
              Icons.warning_outlined,
              "RET'E GÖNDER!",
              Colors.red,
              () {},
            ),
            _buildActionIcon(
              Icons.update,
              "Durum Güncelle",
              Colors.blueGrey,
              () {
                rightmodel.updatePhoneStatusDialog(
                  context,
                  widget.user.phoneStatus ?? '',
                  (p0) {},
                );
              },
            ),
            _buildActionIcon(
              Icons.block,
              "Hesabı Askıya Al",
              Colors.red,
              () {
                final String message =
                    Provider.of<UserManager>(context, listen: false)
                        .blockUser(widget.user);
                rightmodel.showDangerDialog(context, message);
              },
            ),
          ]),

          /// **📅 Randevu & Not Yönetimi**
          _buildSectionTitle(
            "📅 Randevu & Notlar",
          ),
          _buildIconWrap([
            _buildActionIcon(
              Icons.calendar_today,
              "Randevu Planla",
              Colors.purple,
              () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DateNoteView(),
                    ));
              },
            ),
            _buildActionIcon(
              Icons.note_add,
              "Not Ekle",
              Colors.blueGrey,
              () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonelUserDetailPage(
                        user: widget.user,
                        index: 1,
                      ),
                    ));
              },
            ),
          ]),

          /// **🔔 Hatırlatıcılar & Takvim**
          _buildSectionTitle("🔔 Hatırlatıcılar"),
          _buildIconWrap([
            _buildActionIcon(Icons.alarm, "Hatırlatıcı Ekle", Colors.red),
            _buildActionIcon(Icons.event, "Takvim Entegrasyonu", Colors.teal),
          ]),
        ],
      ),
    );
  }

  /// **📌 Bölüm Başlığı**
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  /// **📌 Uzun Metinler Alt Alta Yazılsın**
  Widget _buildIconWrap(List<Widget> icons) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 10, // **Her ikon arasına 10px boşluk**
        runSpacing: 12, // **Eğer satır dolarsa alt satırın boşluğu**
        alignment: WrapAlignment.start,
        children: icons.map((icon) {
          return SizedBox(
            width: 90, // **Maksimum genişlik**
            child: icon, // **Alt alta yazılması için sıkıştırma**
          );
        }).toList(),
      ),
    );
  }

  /// **📌 İşlem İkonu (Uzun Metinler İçin Alt Alta)**
  Widget _buildActionIcon(IconData icon, String label, Color color,
      [void Function()? onTap]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.15), // Hafif renk tonu
            child: Icon(icon, size: 28, color: color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center, // **Metni ortala**
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          maxLines: 2, // **Maksimum 2 satır olacak**
          overflow:
              TextOverflow.ellipsis, // **Uzun metinler taşarsa kesilecek**
        ),
      ],
    );
  }
}

class _TopEditUSerInfoBar extends StatelessWidget {
  const _TopEditUSerInfoBar({required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// **Profil Fotoğrafı veya Kullanıcı Baş Harfi**
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.blue,
          child: Text(
            user.name[0].toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),

        /// **Kullanıcı Bilgileri**
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Text("CRM No: ${user.id}",
                  style: TextStyle(color: Colors.grey[600])),
              Text("Durumu: ${user.phoneStatus}",
                  style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),

        /// **Düzenleme Butonu**
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () {
            print('selam');
          },
        ),
      ],
    );
  }
}

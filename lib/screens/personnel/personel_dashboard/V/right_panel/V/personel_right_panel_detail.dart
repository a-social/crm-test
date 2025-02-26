import 'package:crm_k/core/widgets/user_detail/V/user_detail_view.dart';
import 'package:crm_k/screens/personnel/personel_dashboard/V/right_panel/V/right_bar/communication_notes_page.dart';
import 'package:crm_k/screens/personnel/personel_dashboard/V/right_panel/V/right_bar/management_page.dart';
import 'package:crm_k/screens/personnel/personel_dashboard/V/right_panel/V/right_bar/user_transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:crm_k/core/widgets/user_detail/other_v/user_info_card.dart';

class PersonelUserDetailPage extends StatefulWidget {
  final User user;
  final int? index;

  const PersonelUserDetailPage({super.key, required this.user, this.index});

  @override
  _PersonelUserDetailPageState createState() => _PersonelUserDetailPageState();
}

class _PersonelUserDetailPageState extends State<PersonelUserDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.index ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              /// Üst Menü - Geri Butonu
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        size: 30, color: Colors.blue),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              UserDetailWidget(user: widget.user),
                        );
                      },
                      child: Text('Eski Görünümü Aç'))
                ],
              ),
              const SizedBox(height: 10),

              /// Kullanıcı Bilgileri (SOL) + İşlem Alanları (SAĞ)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 📌 SOL TARAF - Kullanıcı Bilgileri (Tekrar Ekledim!)
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UserInfoCard(user: widget.user),
                              const SizedBox(height: 20),

                              /// **DETAY BİLGİLERİ GERİ EKLENDİ**
                              _buildDetailTile("Yatırım Tutarı",
                                  "${widget.user.investmentAmount} ₺"),
                              _buildDetailTile("Atanan Temsilci",
                                  widget.user.assignedTo ?? ''),
                              _buildDetailTile("Telefon Durumu",
                                  widget.user.phoneStatus ?? ''),
                              _buildDetailTile("Son Görüşme Süresi",
                                  "${widget.user.callDuration} dakika"),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    /// 📌 SAĞ TARAF - Sekmeli Sayfalar
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          /// **TAB BAR**
                          TabBar(
                            controller: _tabController,
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.black54,
                            indicatorColor: Colors.blue,
                            tabs: const [
                              Tab(text: "⚙️ İşlem & Yönetim"),
                              Tab(text: "📞 İletişim & Notlar"),
                              Tab(text: "📄 Hareketler"),
                            ],
                          ),

                          /// **SEKMELERİN YÖNLENDİĞİ SAYFALAR**
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                ManagementPage(user: widget.user),
                                CommunicationNotesPage(user: widget.user),
                                UserTransactionsPage(
                                    user: widget
                                        .user), // 📄 Kullanıcı Hareketleri
                                // 📞 İletişim & Notlar
                                // ⚙️ İşlem ve Yönetim
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}

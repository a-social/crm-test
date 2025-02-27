import 'package:crm_k/core/models/personel_model/manager/personel_manager.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';

import 'package:crm_k/core/widgets/user_detail/other_v/contact_actions.dart';
import 'package:crm_k/core/widgets/user_detail/other_v/investor_detail_selection.dart';

import 'package:crm_k/core/widgets/user_detail/other_v/user_info_card.dart';
import 'package:crm_k/screens/personnel/personel_dashboard/V/right_panel/V/right_bar/communication_notes_page.dart';
import 'package:flutter/material.dart';

class UserDetailWidget extends StatefulWidget {
  final User user;

  const UserDetailWidget({super.key, required this.user});

  @override
  State<UserDetailWidget> createState() => _UserDetailWidgetState();
}

class _UserDetailWidgetState extends State<UserDetailWidget> {
  final PersonelMainManagerLocal _managerLocal = PersonelMainManagerLocal();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 1000, // Sabit genişlik
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Müşteri Detay Ekranı'),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),

              /// **Ana İçerik**
              Expanded(
                child: Row(
                  children: [
                    /// **Sol Panel (Kullanıcı Bilgileri)**
                    Expanded(
                      child: Column(
                        children: [
                          /// **Kullanıcı Bilgileri**
                          UserInfoCard(user: widget.user),

                          /// **Otomatik Arama Butonu**
                          Card(
                            child: Container(
                              height: 100,
                              padding: const EdgeInsets.all(25),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () {
                                  _managerLocal.callCustomer(
                                      widget.user.phone ??
                                          'Telefon Numarası Boş');
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.call),
                                    SizedBox(width: 15),
                                    Text(
                                      'Otomatik Arama Başlat',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// **Temsilci Seçimi**
                                  const Text(
                                    "Temsilci",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    hint: const Text("Temsilci Seçin"),
                                    items: const [
                                      DropdownMenuItem(
                                          value: "Bora", child: Text("Bora")),
                                      DropdownMenuItem(
                                          value: "Ahmet", child: Text("Ahmet")),
                                      DropdownMenuItem(
                                          value: "Zeynep",
                                          child: Text("Zeynep")),
                                    ],
                                    onChanged: (value) {},
                                  ),
                                  const SizedBox(height: 12),

                                  /// **Hesap Açma Butonları**
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          onPressed: () {},
                                          icon: const Icon(Icons.person_add),
                                          label: const Text("C Hesabı Aç"),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue),
                                          onPressed: () {},
                                          icon: const Icon(Icons.person),
                                          label: const Text("Trader Hesabı Aç"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// **Diğer İşlem Butonları**
                          const SizedBox(height: 12),
                          InvestorSelectionRow(),
                          ContactActions(user: widget.user),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    /// **Sağ Panel (TAB BAR EKLENDİ)**
                    Expanded(
                      child: DefaultTabController(
                        length: 4, // **4 Sekme**
                        child: Column(
                          children: [
                            /// **TAB BAR (İkonlarla birlikte)**
                            const TabBar(
                              indicatorColor: Colors.blue,
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.grey,
                              tabs: [
                                Tab(
                                  icon: Icon(Icons.chat_bubble_outline),
                                  text: "NOTLAR",
                                ),
                                Tab(
                                  icon: Icon(Icons.insert_drive_file_outlined),
                                  text: "EVRAKLAR",
                                ),
                                Tab(
                                  icon: Icon(Icons.sync_alt),
                                  text: "HAREKETLER",
                                ),
                                Tab(
                                  icon: Icon(Icons.attach_money),
                                  text: "FİNANS",
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            /// **TAB BAR VIEW (İçerikler)**
                            Expanded(
                              child: TabBarView(
                                children: [
                                  CommunicationNotesPage(
                                      user: widget.user), // **NOTLAR 📜**
                                  Placeholder(), // **EVRAKLAR 📂**
                                  Placeholder(), // **HAREKETLER 🔄**
                                  Placeholder(), // **FİNANS 💰**
                                ],
                              ),
                            ),
                          ],
                        ),
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
}

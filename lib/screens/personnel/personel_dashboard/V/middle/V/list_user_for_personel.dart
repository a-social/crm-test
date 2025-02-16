import 'package:crm_k/core/models/user_model/managers/user_manager.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:crm_k/core/service/filter_service.dart';
import 'package:crm_k/core/service/user_service.dart';
import 'package:crm_k/core/widgets/search/V/search_widget.dart';
import 'package:crm_k/core/widgets/user_detail/V/user_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonelsUserListScreenView extends StatefulWidget {
  const PersonelsUserListScreenView({super.key});

  @override
  _PersonelsUserListScreenViewState createState() =>
      _PersonelsUserListScreenViewState();
}

class _PersonelsUserListScreenViewState
    extends State<PersonelsUserListScreenView> {
  late Future<List<User>> _usersFuture;
  String _searchQuery = ""; // 📌 Arama sorgusu

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    _usersFuture = UserManagerTest.fetchUsersFromJson();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SearchBarWidget(
              hintText: "Arama Yap...",
              onSearch: (query) {
                setState(() {
                  _searchQuery = query.toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(height: 10),

          _buildHeader(context), // 📌 Header korundu

          Expanded(
            child: FutureBuilder<List<User>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Hata: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Hiç kullanıcı yok."));
                }

                // 📌 **Filtrelenmiş Kullanıcı Listesi**
                final users = snapshot.data!
                    .where((user) =>
                        user.name.toLowerCase().contains(_searchQuery) ||
                        user.email.toLowerCase().contains(_searchQuery))
                    .toList();

                if (users.isEmpty) {
                  return const Center(child: Text("Sonuç bulunamadı."));
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return _buildUserCard(context, user);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 📌 **Başlık Satırı (Logo | İsim | Mail | Telefon Durumu)**
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.primaryContainer,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: theme.shadow.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.account_circle, size: 24, color: Color(0xff004e5c)),
          Expanded(
            child: Text(
              "İsim",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.onPrimaryContainer,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              "Mail",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.onPrimaryContainer,
                  ),
            ),
          ),
          Expanded(flex: 3, child: SizedBox()),
          Text(
            "Telefon",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.onPrimaryContainer,
                ),
          ),
        ],
      ),
    );
  }

  /// 📌 **Kullanıcı Kartı (Tasarım Aynı)**
  Widget _buildUserCard(BuildContext context, User user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Provider.of<UserProvider>(context, listen: false).selectUser(user);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 2, child: SizedBox()),
              Text(user.phoneStatus ?? 'None'),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.primary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonelUserListScreenViewHardDetail extends StatefulWidget {
  const PersonelUserListScreenViewHardDetail({super.key});

  @override
  _PersonelUserListScreenViewHardDetailState createState() =>
      _PersonelUserListScreenViewHardDetailState();
}

class _PersonelUserListScreenViewHardDetailState
    extends State<PersonelUserListScreenViewHardDetail> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    _usersFuture = UserManagerTest.fetchUsersFromJson();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildHeader(context),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Hata: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Hiç kullanıcı yok."));
                }

                // **Filtreleme işlemi burada yapılıyor**
                final users = snapshot.data!.where((user) {
                  bool matchesCRM = filterProvider.crmNumber == null ||
                      user.id.toString().contains(filterProvider.crmNumber!);
                  bool matchesName = filterProvider.searchQuery == null ||
                      user.name
                          .toLowerCase()
                          .contains(filterProvider.searchQuery!.toLowerCase());
                  bool matchesEmail = filterProvider.reference == null ||
                      user.email
                          .toLowerCase()
                          .contains(filterProvider.reference!.toLowerCase());
                  bool matchesStatus = filterProvider.status == null ||
                      user.phoneStatus == filterProvider.status;
                  bool matchesMetaNo = filterProvider.metaNo == null ||
                      user.id.toString().contains(filterProvider.metaNo!);
                  bool matchesKYC =
                      !filterProvider.kycApproved || user.tradeStatus == true;

                  // **Tarih null kontrolü**
                  DateTime? createdAt =
                      user.createdAt; // Eğer null olursa null kalır

                  // **Tarih filtresi uygulanıyor, eğer created_at null ise o kullanıcıyı filtreye dahil etme**
                  bool matchesStartDate = filterProvider.startDate == null ||
                      (createdAt != null &&
                          (createdAt.isAfter(filterProvider.startDate!) ||
                              createdAt.isAtSameMomentAs(
                                  filterProvider.startDate!)));
                  bool matchesEndDate = filterProvider.endDate == null ||
                      (createdAt != null &&
                          (createdAt.isBefore(filterProvider.endDate!) ||
                              createdAt
                                  .isAtSameMomentAs(filterProvider.endDate!)));

                  return matchesCRM &&
                      matchesName &&
                      matchesEmail &&
                      matchesStatus &&
                      matchesMetaNo &&
                      matchesKYC &&
                      matchesStartDate &&
                      matchesEndDate;
                }).toList();

                if (users.isEmpty) {
                  return const Center(child: Text("Sonuç bulunamadı."));
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return _buildUserCard(context, user);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.account_circle, size: 24, color: Color(0xff004e5c)),
          Expanded(
            child: Text(
              "İsim",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              "Mail",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              "Telefon Durumu",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, User user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: _getBackgroundColor(user.phoneStatus),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) =>
                UserDetailWidget(user: user), // **Detay ekranını aç**
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  user.phoneStatus ?? 'Bilinmiyor',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade700,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(String? phoneStatus) {
    switch (phoneStatus) {
      case "Yeni Atanan":
        return Colors.grey; // Gri
      case "Yanlış Kişi / No":
        return Colors.red; // Kırmızı
      case "Takipte Kal":
        return Colors.lightBlueAccent; // Açık Mavi
      case "Cevapsız":
        return Colors.blue; // Mavi
      case "İlgili / Sıcak Takip":
        return Colors.pinkAccent; // Pembe
      case "Yatırımcı":
        return Colors.green; // Yeşil
      case "Kara Liste":
        return Colors.black54; // Koyu Gri
      case "İlgilenmiyor":
        return Colors.brown; // Kahverengi
      case "Tekrar Ara":
        return Colors.orange; // Turuncu
      case "Ulaşılamıyor":
        return Colors.yellow.shade600; // Sarı
      default:
        return Colors.white; // Varsayılan
    }
  }
}

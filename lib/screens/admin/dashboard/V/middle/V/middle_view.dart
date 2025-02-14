// ANA İÇERİK
import 'package:crm_k/core/models/personel_model/manager/personel_manager.dart';
import 'package:crm_k/core/models/personel_model/personel_model.dart';
import 'package:crm_k/core/models/user_model/managers/user_manager.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:crm_k/core/service/admin_service.dart';
import 'package:crm_k/core/service/personel_service.dart';
import 'package:crm_k/core/texts/unit_text.dart';
import 'package:crm_k/screens/admin/dashboard/V/middle/graphics_view.dart';
import 'package:crm_k/screens/admin/dashboard/V/right_panel/V/right_panel_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    final personelService = Provider.of<PersonelService>(context);

    return StreamBuilder<List<PersonnelModel>>(
      stream: personelService.getPersonnelStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Hata: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Hiç personel bulunamadı."));
        }

        final List<PersonnelModel> personnelList = snapshot.data!;

        // 🔹 **Yeni Servis Yapısını Kullanan Güncellenmiş İstatistikler**
        final int totalPersonnel = personnelList.length;
        final String topEmployee =
            personelService.getMostActivePersonnel()?.name ?? "Bilinmiyor";
        final String employeeOfTheDay =
            personelService.getPersonnelOfTheDay()?.name ?? "Bilinmiyor";
        final double totalInvestment =
            personnelList.fold(0, (sum, p) => sum + p.totalInvestment);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text("Hoşgeldin, Admin"),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Card(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: StatBox(
                                    title: "Bugün Alınan Yatırım",
                                    value:
                                        "${totalInvestment.toStringAsFixed(2)} ₺",
                                    subValue: "",
                                  ),
                                ),
                                Expanded(
                                  child: StatBox(
                                    title: "Personel Sayısı",
                                    value: "$totalPersonnel",
                                    subValue: "",
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: StatBox(
                                    title: "En Çok Çalışan Personel",
                                    value: topEmployee,
                                    subValue: "",
                                  ),
                                ),
                                Expanded(
                                  child: StatBox(
                                    title: "Günün Personeli",
                                    value: employeeOfTheDay,
                                    subValue: "",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "Personeller",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: const PersonelScreenViewState(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// İSTATİSTİK KUTULARI
class StatBox extends StatelessWidget {
  final String title;
  final String value;
  final String subValue;

  const StatBox(
      {super.key,
      required this.title,
      required this.value,
      required this.subValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.blue[100], borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Text(subValue, style: TextStyle(color: Colors.green[700])),
            ],
          ),
        ],
      ),
    );
  }
}

// GÖREV ÖĞELERİ
class TaskItem extends StatelessWidget {
  final String title;
  final String status;
  final String hours;

  const TaskItem(
      {super.key,
      required this.title,
      required this.status,
      required this.hours});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(status),
      trailing:
          Text(hours, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

//userlar buradan gözükecekler,
//api butonu kaldırılacak direkt olarak apiden çekilecek yada umutla konuşulacak

class UserListScreenView extends StatefulWidget {
  const UserListScreenView({super.key});

  @override
  _UserListScreenViewState createState() => _UserListScreenViewState();
}

class _UserListScreenViewState extends State<UserListScreenView> {
  late Future<List<User>> _usersFuture;
  bool isApi = false; // Varsayılan olarak API'den veri çekecek

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    _usersFuture = isApi
        ? UserManagerTest.fetchUsersFromApi() // API'den çek
        : UserManagerTest.fetchUsersFromJson(); // JSON'dan çek
    setState(() {}); // Sayfayı güncelle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Kullanıcılar"),
      //   actions: [
      //     Switch(
      //       value: isApi,
      //       onChanged: (value) {
      //         setState(() {
      //           isApi = value;
      //           _fetchUsers();
      //         });
      //       },
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Text(isApi ? "API" : "JSON"),
      //     )
      //   ],
      // ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Hiç kullanıcı yok."));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(users[index].name.isNotEmpty
                        ? users[index].name[0].toUpperCase()
                        : "?"),
                  ),
                  title: Text(users[index].name),
                  subtitle: Text(users[index].email),
                  onTap: () {
                    Provider.of<UserProvider>(context, listen: false)
                        .selectUser(users[index]); // 📌 Sağ paneli güncelle
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PersonelScreenViewState extends StatefulWidget {
  const PersonelScreenViewState({super.key});

  @override
  _PersonelScreenViewStateState createState() =>
      _PersonelScreenViewStateState();
}

class _PersonelScreenViewStateState extends State<PersonelScreenViewState> {
  late Stream<List<PersonnelModel>> _personnelStream;
  bool isApi = false; // Varsayılan olarak API'den veri çekecek

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    _personnelStream = PersonelService().getPersonnelStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<PersonnelModel>>(
        stream: _personnelStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Hiç personel yok."));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(users[index].name.isNotEmpty
                        ? users[index].name[0].toUpperCase()
                        : "?"),
                  ),
                  title: Text(users[index].name),
                  subtitle: Text(users[index].email),
                  onTap: () {
                    Provider.of<PersonelProviderSelect>(context, listen: false)
                        .selectUser(users[index]);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

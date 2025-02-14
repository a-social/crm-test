import 'package:crm_k/core/models/user_model/managers/user_manager.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:crm_k/screens/admin/dashboard/V/right_panel/V/right_panel_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    _usersFuture = UserManagerTest.fetchUsersFromApi(context);
    // ? UserManagerTest.fetchUsersFromApi() // API'den çek
    // JSON'dan çek
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

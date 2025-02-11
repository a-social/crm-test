import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestAppState extends StatefulWidget {
  const TestAppState({super.key});

  @override
  _TestAppStateState createState() => _TestAppStateState();
}

class _TestAppStateState extends State<TestAppState> {
  late Future<List<dynamic>> usersFuture;

  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('http://localhost:8080/users'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Veri alınamadı: ${response.statusCode}");
    }
  }

  Future<void> addUser() async {
    await http.post(Uri.parse('http://localhost:8080/add-user'));
    setState(() {
      usersFuture = fetchUsers(); // Kullanıcı eklendikten sonra verileri yenile
    });
  }

  @override
  void initState() {
    super.initState();
    usersFuture = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Shelf Backend Test')),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: addUser,
              child: Text('Kullanıcı Ekle'),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Hata: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Hiç kullanıcı yok."));
                  }

                  final users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(users[index]['name']),
                        subtitle: Text(users[index]['email']),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

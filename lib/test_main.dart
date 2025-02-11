import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> users = [];

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http://localhost:8080/users'));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    }
  }

  Future<void> addUser() async {
    await http.post(Uri.parse('http://localhost:8080/add-user'));
    fetchUsers(); // Kullanıcı ekledikten sonra listeyi yenile
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
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
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(users[index]['name']),
                    subtitle: Text(users[index]['email']),
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

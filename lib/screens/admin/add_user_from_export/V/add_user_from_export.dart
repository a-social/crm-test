import 'dart:convert';
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UploadUserScreen extends StatefulWidget {
  const UploadUserScreen({super.key});

  @override
  _UploadUserScreenState createState() => _UploadUserScreenState();
}

class _UploadUserScreenState extends State<UploadUserScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _isDataChanged = false;

  Future<void> _pickFile({html.File? droppedFile}) async {
    html.File file;
    if (droppedFile != null) {
      file = droppedFile;
    } else {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
        ..accept = '.csv';
      uploadInput.click();

      await uploadInput.onChange.first;
      file = uploadInput.files!.first;
    }

    final reader = html.FileReader();
    reader.readAsText(file);
    await reader.onLoad.first;

    final csvString = reader.result as String;
    _processCsv(csvString);
  }

  void _processCsv(String csvString) {
    List<List<dynamic>> csvTable =
        const CsvToListConverter().convert(csvString);
    List<Map<String, dynamic>> newUsers = [];

    for (var i = 1; i < csvTable.length; i++) {
      newUsers.add({
        "id": csvTable[i][0].toString(),
        "name": csvTable[i][1],
        "email": csvTable[i][2],
        "phone": csvTable[i][3],
        "trade_status": csvTable[i][4] == 'true',
        "investment_status": csvTable[i][5] == 'true',
        "investment_amount": int.tryParse(csvTable[i][6].toString()) ?? 0,
        "assigned_to": csvTable[i][7],
        "call_duration": int.tryParse(csvTable[i][8].toString()) ?? 0,
        "phone_status": csvTable[i][9],
        "previous_investment": csvTable[i][10] == 'true',
        "expected_investment_date": csvTable[i][11],
        "created_at": csvTable[i][12],
      });
    }

    setState(() {
      _users = newUsers;
      _isDataChanged = true;
    });

    print("✅ ${newUsers.length} kullanıcı eklendi.");
  }

  Future<void> _updateUsersJson() async {
    try {
      final String usersData = await rootBundle.loadString('assets/users.json');
      List<dynamic> existingUsers = json.decode(usersData);

      existingUsers.addAll(_users);

      _downloadJsonFile(existingUsers, "users.json");

      setState(() {
        _users.clear();
        _isDataChanged = false;
      });

      print("📁 Kullanıcılar başarıyla users.json dosyasına eklendi.");
    } catch (e) {
      print("❌ Hata: $e");
    }
  }

  void _downloadJsonFile(dynamic data, String fileName) {
    final jsonString = jsonEncode(data);
    final blob = html.Blob([jsonString], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  void _downloadCsvFile() {
    List<List<dynamic>> csvData = [
      [
        "ID",
        "İsim",
        "E-Posta",
        "Telefon",
        "Yatırım Durumu",
        "Atanan Personel",
        "Oluşturulma Tarihi"
      ],
      ..._users.map((user) => [
            user["id"],
            user["name"],
            user["email"],
            user["phone"],
            user["investment_status"] ? "Var" : "Yok",
            user["assigned_to"],
            user["created_at"],
          ])
    ];

    final csvString = const ListToCsvConverter().convert(csvData);
    final blob = html.Blob([csvString], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "users.csv")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<bool> _onWillPop() async {
    if (_isDataChanged) {
      bool? shouldLeave = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Değişiklikler Kaydedilmedi!"),
          content: const Text(
              "Yaptığınız değişiklikler kaybolacak. Çıkmak istediğinize emin misiniz?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Hayır"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Evet, Çık"),
            ),
          ],
        ),
      );
      return shouldLeave ?? false;
    }
    return true;
  }

  void _clearData() {
    setState(() {
      _users.clear();
      _isDataChanged = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDataChanged,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          bool exitConfirmed = await _onWillPop();
          if (exitConfirmed) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DragTarget<html.File>(
                onAcceptWithDetails: (details) {
                  _pickFile(droppedFile: details.data);
                },
                builder: (context, candidateData, rejectedData) {
                  return GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.upload_file,
                                size: 50, color: Colors.blue),
                            const SizedBox(height: 10),
                            Text(
                              "Dosya Seç veya Sürükleyip Bırak",
                              style: TextStyle(
                                  color: Colors.blue.shade800, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _clearData,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Dosyayı Temizle"),
                  ),
                  ElevatedButton(
                    onPressed: _updateUsersJson,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("JSON Olarak Kaydet"),
                  ),
                  ElevatedButton(
                    onPressed: _downloadCsvFile,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    child: const Text("CSV Olarak Kaydet"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_users[index]["name"]),
                      subtitle: Text(_users[index]["email"]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

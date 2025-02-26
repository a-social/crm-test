import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectPersonnelScreen extends StatefulWidget {
  final String selectedCompany; // Önceki ekrandan gelen firma

  const SelectPersonnelScreen({super.key, required this.selectedCompany});

  @override
  _SelectPersonnelScreenState createState() => _SelectPersonnelScreenState();
}

class _SelectPersonnelScreenState extends State<SelectPersonnelScreen> {
  List<Map<String, dynamic>> _allPersonnel = [];
  List<Map<String, dynamic>> _selectedPersonnel = [];

  @override
  void initState() {
    super.initState();
    _loadPersonnel();
  }

  Future<void> _loadPersonnel() async {
    final String response =
        await rootBundle.loadString('assets/personnel.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      _allPersonnel = List<Map<String, dynamic>>.from(data);
    });
  }

  void _toggleSelection(Map<String, dynamic> personnel) {
    setState(() {
      if (_selectedPersonnel.contains(personnel)) {
        _selectedPersonnel.remove(personnel);
      } else {
        _selectedPersonnel.add(personnel);
      }
    });
  }

  void _goToNextStep() {
    if (_selectedPersonnel.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SummaryScreen(
            data: widget.selectedCompany,
            data2: _selectedPersonnel.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),

          // 📌 Tüm Personelleri Ekle Butonu
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedPersonnel = List.from(_allPersonnel);
              });
            },
            child: const Text("Tüm Personelleri Ekle"),
          ),

          const SizedBox(height: 10),

          // 📌 Sol: Tüm Personeller | Sağ: Seçili Personeller
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildPersonnelList(_allPersonnel, false)),
                const VerticalDivider(width: 20),
                Expanded(child: _buildPersonnelList(_selectedPersonnel, true)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 📌 Devam Butonu
          ElevatedButton(
            onPressed: _selectedPersonnel.isNotEmpty ? _goToNextStep : null,
            child: const Text("Devam Et"),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonnelList(
      List<Map<String, dynamic>> personnelList, bool isSelectedList) {
    return Column(
      children: [
        Text(isSelectedList ? "Seçili Personeller" : "Tüm Personeller",
            style: const TextStyle(fontSize: 18)),
        Expanded(
          child: ListView.builder(
            itemCount: personnelList.length,
            itemBuilder: (context, index) {
              final personnel = personnelList[index];
              bool isSelected = _selectedPersonnel.contains(personnel);

              return ListTile(
                title: Text(personnel["name"]),
                trailing: IconButton(
                  icon: Icon(Icons.check_circle,
                      color: isSelected ? Colors.blue : Colors.grey),
                  onPressed: () => _toggleSelection(personnel),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key, required this.data, required this.data2});
  final String data;
  final String data2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [Text(data), Text(data2)],
        ),
      ),
    );
  }
}

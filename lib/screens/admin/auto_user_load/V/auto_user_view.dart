import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminFunctionLoadDatButton extends StatefulWidget {
  const AdminFunctionLoadDatButton({super.key});

  @override
  _AdminFunctionLoadDatButtonState createState() =>
      _AdminFunctionLoadDatButtonState();
}

class _AdminFunctionLoadDatButtonState
    extends State<AdminFunctionLoadDatButton> {
  int _currentStep = 0;
  String? _selectedCompany; // Seçilen firma

  void _nextStep() {
    if (_currentStep < 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌 ADIM GÖSTERGESİ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepIndicator("1. Firma Seçimi", 0),
                _buildStepIndicator("2. İlgili Personel Seçimi", 1),
                _buildStepIndicator("3. Ön Gösterim", 2),
                _buildStepIndicator("4. Onaylama", 3),
              ],
            ),

            const SizedBox(height: 20),

            // 📌 ADIMLARA GÖRE GÖSTERİLEN İÇERİK
            Expanded(
              child: _currentStep == 0
                  ? _buildCompanySelection()
                  : _buildSecondStep(),
            ),

            // 📌 BUTONLAR (GERİ / DEVAM)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  ElevatedButton(
                    onPressed: _previousStep,
                    child: const Text("Geri"),
                  ),
                ElevatedButton(
                  onPressed: _selectedCompany != null || _currentStep == 1
                      ? _nextStep
                      : null,
                  child: const Text("Devam Et"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 📌 ADIM GÖSTERGESİ (Üstteki Navigation)
  Widget _buildStepIndicator(String title, int stepIndex) {
    bool isActive = _currentStep >= stepIndex;
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isActive ? Colors.blue : Colors.grey,
          child: Text("${stepIndex + 1}",
              style: const TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 5),
        Text(title,
            style: TextStyle(color: isActive ? Colors.black : Colors.grey)),
      ],
    );
  }

  // 📌 1. ADIM: FİRMA SEÇİMİ
  Widget _buildCompanySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Lütfen bir firma seçin:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        // Firma Seçenekleri (Buton)
        Row(
          children: [
            _buildCompanyButton("1. Firma"),
            const SizedBox(width: 10),
            _buildCompanyButton("2. Firma"),
          ],
        ),

        const SizedBox(height: 20),

        // Dropdown ile seçim alternatifi
        DropdownButtonFormField<String>(
          value: _selectedCompany,
          hint: const Text("Firma Seçin"),
          items: ["1. Firma", "2. Firma"]
              .map(
                  (firma) => DropdownMenuItem(value: firma, child: Text(firma)))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCompany = value;
            });
          },
        ),
      ],
    );
  }

  // 📌 Firma Seçim Butonları
  Widget _buildCompanyButton(String companyName) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCompany = companyName;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _selectedCompany == companyName ? Colors.blue : Colors.grey,
      ),
      child: Text(companyName),
    );
  }

  // 📌 2. ADIM: PLACEHOLDER (Firma Bilgisi Görünecek)
  Widget _buildSecondStep() {
    return Center(
      child: Text(
        _selectedCompany != null
            ? "Seçilen Firma: $_selectedCompany"
            : "Henüz firma seçilmedi",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SelectPersonnelScreen extends StatefulWidget {
  final String selectedCompany; // Önceki ekrandan gelen firma

  const _SelectPersonnelScreen({required this.selectedCompany});

  @override
  _SelectPersonnelScreenState createState() => _SelectPersonnelScreenState();
}

class _SelectPersonnelScreenState extends State<_SelectPersonnelScreen> {
  List<Map<String, dynamic>> _allPersonnel = []; // Tüm personeller
  List<Map<String, dynamic>> _selectedPersonnel = []; // Seçili personeller

  @override
  void initState() {
    super.initState();
    _loadPersonnel();
  }

  // 📌 JSON'dan personel verisini oku
  Future<void> _loadPersonnel() async {
    final String response =
        await rootBundle.loadString('assets/personnel.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      _allPersonnel = List<Map<String, dynamic>>.from(data);
    });
  }

  // 📌 Personel seçme fonksiyonu
  void _toggleSelection(Map<String, dynamic> personnel) {
    setState(() {
      if (_selectedPersonnel.contains(personnel)) {
        _selectedPersonnel.remove(personnel);
      } else {
        _selectedPersonnel.add(personnel);
      }
    });
  }

  // 📌 Tüm personelleri seç
  void _selectAllPersonnel() {
    setState(() {
      _selectedPersonnel = List.from(_allPersonnel);
    });
  }

  // 📌 Devam butonu
  void _goToNextStep() {
    if (_selectedPersonnel.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NextStepScreen(
            selectedCompany: widget.selectedCompany,
            selectedPersonnel: _selectedPersonnel,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌 ADIM GÖSTERGESİ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepIndicator("1. Firma Seçimi", true),
                _buildStepIndicator("2. Personel Seçimi", true),
                _buildStepIndicator("3. Özet", false),
              ],
            ),
            const SizedBox(height: 20),

            // 📌 Tüm Personelleri Ekle Butonu
            ElevatedButton(
              onPressed: _selectAllPersonnel,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Tüm Personelleri Ekle"),
            ),
            const SizedBox(height: 10),

            // 📌 2 KOLONLU PERSONEL SEÇİM LİSTESİ
            Expanded(
              child: Row(
                children: [
                  // 📌 Sol Taraf: Tüm Personeller Listesi
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tüm Personeller",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Expanded(
                            child: _buildPersonnelList(_allPersonnel, false)),
                      ],
                    ),
                  ),

                  const VerticalDivider(width: 20, thickness: 2),

                  // 📌 Sağ Taraf: Seçili Personeller Listesi
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Seçili Personeller",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Expanded(
                            child:
                                _buildPersonnelList(_selectedPersonnel, true)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📌 Devam Butonu
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _selectedPersonnel.isNotEmpty ? _goToNextStep : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Devam Et"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Adım Gösterge Yapısı
  Widget _buildStepIndicator(String title, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isActive ? Colors.blue : Colors.grey,
          child: Text(
            title.substring(0, 1),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 5),
        Text(title,
            style: TextStyle(color: isActive ? Colors.black : Colors.grey)),
      ],
    );
  }

  // 📌 Personel Listesi
  Widget _buildPersonnelList(
      List<Map<String, dynamic>> personnelList, bool isSelectedList) {
    return ListView.builder(
      itemCount: personnelList.length,
      itemBuilder: (context, index) {
        final personnel = personnelList[index];
        bool isSelected = _selectedPersonnel.contains(personnel);

        return Card(
          color: isSelected ? Colors.lightBlue.shade100 : Colors.white,
          child: ListTile(
            title: Text(personnel["name"]),
            subtitle: Text(personnel["email"]),
            trailing: IconButton(
              icon: Icon(Icons.radio_button_checked,
                  color: isSelected ? Colors.blue : Colors.grey),
              onPressed: () => _toggleSelection(personnel),
            ),
          ),
        );
      },
    );
  }
}

// 📌 SONRAKİ EKRAN (ÖZET)
class NextStepScreen extends StatelessWidget {
  final String selectedCompany;
  final List<Map<String, dynamic>> selectedPersonnel;

  const NextStepScreen(
      {super.key,
      required this.selectedCompany,
      required this.selectedPersonnel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Seçilen Firma:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(selectedCompany, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            const Text("Seçilen Personeller:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: selectedPersonnel.length,
                itemBuilder: (context, index) {
                  final personnel = selectedPersonnel[index];
                  return ListTile(
                    title: Text(personnel["name"]),
                    subtitle: Text(personnel["email"]),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 📌 Tamamlandı Butonu
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Tamamlandı"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

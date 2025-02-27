import 'package:flutter/material.dart';
import 'package:crm_k/core/models/user_model/user_mode.dart';

class CommunicationNotesPage extends StatefulWidget {
  // hatırlatıcı kısmı eklenecek
  final User user;

  const CommunicationNotesPage({super.key, required this.user});

  @override
  _CommunicationNotesPageState createState() => _CommunicationNotesPageState();
}

class _CommunicationNotesPageState extends State<CommunicationNotesPage> {
  final TextEditingController _noteController = TextEditingController();
  final List<Map<String, String>> _notes = [
    {"date": "15.02.2025", "content": "Müşteri cevap vermedi."},
    {"date": "14.02.2025", "content": "Yanlış numara bildirildi."},
    {"date": "13.02.2025", "content": "Yatırım yapmayı düşündüğünü söyledi."},
  ];

  String _selectedStatus = "Cevapsız"; // Varsayılan durum

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// **📞 Arama Geçmişi (Timeline Formatında)**
          Text("📞 Arama Geçmişi", style: _sectionTitleStyle()),
          const SizedBox(height: 10),
          Expanded(child: _buildCallHistory()),

          const SizedBox(height: 20),

          /// **📝 Not Ekleme Alanı (Durum Seçimi İçeriyor)**
          Text("📝 Not Ekle", style: _sectionTitleStyle()),
          const SizedBox(height: 10),
          _buildNoteInput(),
        ],
      ),
    );
  }

  /// **📌 Timeline Formatında Arama Geçmişi**
  Widget _buildCallHistory() {
    return ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return _buildTimelineItem(note["date"]!, note["content"]!);
      },
    );
  }

  /// **📌 Tek Bir Timeline Elemanı**
  Widget _buildTimelineItem(String date, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// **Sol Tarafta Daire ve Çizgi**
          Column(
            children: [
              CircleAvatar(
                radius: 6,
                backgroundColor: Colors.blue,
              ),
            ],
          ),
          const SizedBox(width: 10),

          /// **Sağ Tarafta Not Bilgisi**
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(content, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **📌 Not Ekleme Alanı (Dropdown ile Durum Seçme)**
  Widget _buildNoteInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// **📌 Açılır Menü (Dropdown) ile Kullanıcı Durumu Seçimi**
        DropdownButtonFormField<String>(
          value: _selectedStatus,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: [
            "Yeni Atanan",
            "Yanlış Kişi / No",
            "Takipte Kal",
            "Cevapsız",
            "İlgili / Sıcak Takip",
            "Yatırımcı",
            "Kara Liste",
            "İlgilenmiyor",
            "Tekrar Ara",
            "Ulaşılamıyor",
          ].map((status) {
            return DropdownMenuItem(
              value: status,
              child: Row(
                children: [
                  Icon(Icons.circle, size: 12, color: _getStatusColor(status)),
                  const SizedBox(width: 8),
                  Text(status),
                ],
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                _selectedStatus = newValue;
                _noteController.text =
                    newValue; // **Text'e durum yazdırıyoruz**
              });
            }
          },
        ),

        const SizedBox(height: 10),

        /// **📌 Not Yazma Alanı**
        TextField(
          controller: _noteController,
          decoration: InputDecoration(
            hintText: "Notunuzu girin...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 10),

        /// **📌 Butonlar**
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                _noteController.clear();
              },
              child: const Text(
                "Temizle",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                if (_noteController.text.isNotEmpty) {
                  setState(() {
                    _notes.add({
                      "date": "Bugün",
                      "content": _noteController.text,
                    });
                  });
                  _noteController.clear();
                }
              },
              child: const Text(
                "Ekle",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// **📌 Başlık Stili**
  TextStyle _sectionTitleStyle() {
    return const TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue);
  }

  /// **📌 Durumlara Göre Renk Atama**
  Color _getStatusColor(String status) {
    switch (status) {
      case "Yeni Atanan":
        return Colors.grey;
      case "Yanlış Kişi / No":
        return Colors.red;
      case "Takipte Kal":
        return Colors.lightBlueAccent;
      case "Cevapsız":
        return Colors.blue;
      case "İlgili / Sıcak Takip":
        return Colors.pinkAccent;
      case "Yatırımcı":
        return Colors.green;
      case "Kara Liste":
        return Colors.black54;
      case "İlgilenmiyor":
        return Colors.brown;
      case "Tekrar Ara":
        return Colors.orange;
      case "Ulaşılamıyor":
        return Colors.yellow.shade600;
      default:
        return Colors.white;
    }
  }
}

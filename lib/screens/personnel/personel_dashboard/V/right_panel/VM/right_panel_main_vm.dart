import 'package:crm_k/core/models/personel_model/manager/personel_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RightPanelMainVm {
  void showCustomAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Uyarı"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tamam"),
            ),
          ],
        );
      },
    );
  }

  void showDangerDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Emin Misin ?"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("İptal Et"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Engelle Hıyarı"),
            ),
          ],
        );
      },
    );
  }

  void addInvestmentAmount(BuildContext context, String userId) {
    TextEditingController amountController = TextEditingController();
    String selectedCurrency = "₺"; // Varsayılan para birimi TL

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Yatırım Miktarı Ekle"),
          content: Row(
            children: [
              // Para Birimi Seçimi
              DropdownButton<String>(
                value: selectedCurrency,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedCurrency = newValue;
                  }
                },
                items: [
                  DropdownMenuItem(value: "₺", child: Text("₺")),
                ],
              ),
              const SizedBox(width: 10),
              // Yalnızca Sayı Girilebilen TextField
              Expanded(
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Sadece rakam girişi
                  ],
                  decoration: InputDecoration(
                    hintText: "Tutarı girin",
                    suffixText: selectedCurrency, // Varsayılan TL simgesi
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () async {
                if (amountController.text.isNotEmpty) {
                  final PersonelMainManager manager = PersonelMainManager();
                  await manager.updateInvestmentAmount(context, userId,
                      double.parse(amountController.text.trim()));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Yatırım miktarı ${amountController.text}$selectedCurrency eklenmiştir")),
                  );
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("Ekle"),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel, color: Colors.red),
              label: const Text("İptal", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void updatePhoneStatusDialog(BuildContext context, String currentStatus,
      Function(String) onStatusUpdated) {
    String selectedStatus = currentStatus;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Durum Güncelle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
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
                        Icon(Icons.circle,
                            size: 12, color: _getStatusColor(status)),
                        const SizedBox(width: 8),
                        Text(status),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    selectedStatus = newValue;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel, color: Colors.red),
              label: const Text("İptal", style: TextStyle(color: Colors.red)),
            ),
            TextButton.icon(
              onPressed: () {
                onStatusUpdated(selectedStatus);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          "Telefon durumu \"$selectedStatus\" olarak güncellendi.")),
                );
              },
              icon: const Icon(Icons.check, color: Colors.green),
              label:
                  const Text("Güncelle", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
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

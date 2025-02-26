import 'package:flutter/material.dart';

class DateNoteVM extends ChangeNotifier {
  DateTime selectedDate =
      DateTime.now().add(const Duration(days: 1)); // İlk seçim yarın
  final Map<DateTime, Map<String, dynamic>> notes =
      {}; // Tarih bazlı not ve renk saklama
  final TextEditingController noteController = TextEditingController();
  Color selectedColor = Colors.blue; // Varsayılan renk

  /// **📌 Tarih Seçme**
  void selectDate(DateTime date) {
    selectedDate = date;
    noteController.text = notes[date]?["note"] ?? ""; // Önceki not varsa yükle
    selectedColor =
        notes[date]?["color"] ?? Colors.blue; // Önceki renk varsa yükle
    notifyListeners();
  }

  /// **📌 Not Kaydetme**
  void saveNote() {
    if (noteController.text.isNotEmpty) {
      notes[selectedDate] = {
        "note": noteController.text,
        "color": selectedColor
      };
      notifyListeners();
    }
  }

  /// **📌 Renk Değiştirme**
  void changeColor(Color newColor) {
    selectedColor = newColor;
    notifyListeners();
  }
}

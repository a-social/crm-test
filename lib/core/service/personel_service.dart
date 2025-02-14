import 'dart:async';
import 'dart:convert';
import 'package:crm_k/core/models/personel_model/personel_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PersonnelProvider extends ChangeNotifier {
  PersonnelModel? _personel;

  PersonnelModel? get personel => _personel;

  Future<void> fetchPersonnel(String email) async {
    try {
      //şimdilik localde çalışıyor sonrasında databaseden gelen veri üzerine çalışılacak
      String jsonString = await rootBundle.loadString('assets/personnel.json');
      List<dynamic> jsonData = json.decode(jsonString);

      var foundPersonel = jsonData.firstWhere(
        (personnel) => personnel['email'] == email,
        orElse: () => null,
      );

      if (foundPersonel != null) {
        _personel = PersonnelModel.fromJson(foundPersonel);
        notifyListeners(); // UI'yi güncelle
      } else {
        _personel = null; // Eğer personel bulunmazsa temizle
      }
    } catch (e) {
      print("personnel verisi yüklenirken hata oluştu: $e");
    }
  }
}

class PersonelProviderSelect extends ChangeNotifier {
  PersonnelModel? _selectedPersonel;

  PersonnelModel? get selectedPersonel => _selectedPersonel;

  void selectUser(PersonnelModel personnel) {
    _selectedPersonel = personnel;
    notifyListeners(); // Sağ panelin güncellenmesi için haber ver
  }
}

class PersonelService with ChangeNotifier {
  final StreamController<List<PersonnelModel>> _controller =
      StreamController<List<PersonnelModel>>.broadcast();

  List<PersonnelModel> _personnelList = [];

  PersonelService() {
    _startStream();
  }

  /// 🔹 **Eski Stream Metodu Kaldı** (UI'nin bozulmaması için)
  Stream<List<PersonnelModel>> getPersonnelStream() => _controller.stream;

  /// 🔹 **Yeni Anlık Veri Metodu**
  List<PersonnelModel> get currentPersonnelList => _personnelList;

  /// 🔹 **Veriyi Güncelleyen Stream**
  void _startStream() async {
    while (true) {
      await Future.delayed(
          const Duration(seconds: 1)); // 5 saniyede bir güncelle

      try {
        String jsonString =
            await rootBundle.loadString('assets/personnel.json');
        List<dynamic> jsonData = json.decode(jsonString);

        _personnelList =
            jsonData.map((data) => PersonnelModel.fromJson(data)).toList();

        _controller.add(_personnelList); // Stream'e yeni veriyi gönder
        notifyListeners(); // UI'yi güncelle
      } catch (e) {
        _controller.addError("Veri yüklenirken hata oluştu: $e");
      }
    }
  }

  /// 🔹 **En Çok Çalışan Personel (Atanan Müşteri Sayısına Göre)**
  PersonnelModel? getMostActivePersonnel() {
    if (_personnelList.isEmpty) return null;
    _personnelList.sort((a, b) =>
        b.assignedCustomers.length.compareTo(a.assignedCustomers.length));
    return _personnelList.first;
  }

  /// 🔹 **Günün Personeli (Toplam Yatırım Miktarına Göre)**
  PersonnelModel? getPersonnelOfTheDay() {
    if (_personnelList.isEmpty) return null;
    _personnelList
        .sort((a, b) => b.totalInvestment.compareTo(a.totalInvestment));
    return _personnelList.first;
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

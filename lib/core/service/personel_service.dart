import 'dart:async';
import 'dart:convert';
import 'package:crm_k/core/models/personel_model/personel_model.dart';
import 'package:crm_k/core/service/admin_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

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

  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:8080"));

  /// 🔹 **Eski Stream Metodu (UI için halen çalışıyor)**
  Stream<List<PersonnelModel>> getPersonnelStream() => _controller.stream;

  /// 🔹 **Anlık Personel Listesi**
  List<PersonnelModel> get currentPersonnelList => _personnelList;

  PersonelService() {
    _fetchPersonnelFromJson(); // Uygulama başlarken JSON'dan veriyi al
    _startStream(); // Canlı veri akışı başlat
  }

  /// **📌 Personel Listesini JSON'dan Oku**
  Future<void> _fetchPersonnelFromJson() async {
    try {
      String jsonString = await rootBundle.loadString('assets/personnel.json');
      List<dynamic> jsonData = json.decode(jsonString);

      _personnelList =
          jsonData.map((data) => PersonnelModel.fromJson(data)).toList();

      _controller.add(_personnelList);
      notifyListeners();
    } catch (e) {
      _controller.addError("Veri yüklenirken hata oluştu: $e");
    }
  }

  /// **📌 Personeli Sil**
  Future<void> deletePersonnel(BuildContext context, String email) async {
    final String? token =
        Provider.of<AdminProvider>(context, listen: false).token;

    if (token == null) {
      throw Exception("Yetkisiz işlem: Token bulunamadı!");
    }

    try {
      final response = await _dio.delete(
        "/delete-personnel/$email",
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        _personnelList.removeWhere((person) => person.email == email);
        _controller.add(_personnelList);
        notifyListeners();
      } else {
        throw Exception("Silme başarısız: ${response.data}");
      }
    } catch (e) {
      throw Exception("Silme sırasında hata oluştu: $e");
    }
  }

  /// **📌 Personel Güncelleme**
  Future<void> updatePersonnel(
      BuildContext context, PersonnelModel updatedPerson) async {
    final String? token =
        Provider.of<AdminProvider>(context, listen: false).token;

    if (token == null) {
      throw Exception("Yetkisiz işlem: Token bulunamadı!");
    }

    try {
      Response response = await _dio.put(
        "/update-personnel/${updatedPerson.email}",
        data: jsonEncode(updatedPerson.toJson()),
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        int index = _personnelList
            .indexWhere((person) => person.email == updatedPerson.email);
        if (index != -1) {
          _personnelList[index] = updatedPerson;
          _controller.add(_personnelList);
          notifyListeners();
        }
      } else {
        throw Exception("Güncelleme başarısız: ${response.data}");
      }
    } catch (e) {
      throw Exception("Güncelleme sırasında hata oluştu: $e");
    }
  }

  /// **📌 En Çok Çalışan Personel (Atanan Müşteri Sayısına Göre)**
  PersonnelModel? getMostActivePersonnel() {
    if (_personnelList.isEmpty) return null;
    _personnelList.sort((a, b) =>
        b.assignedCustomers.length.compareTo(a.assignedCustomers.length));
    return _personnelList.first;
  }

  /// **📌 Günün Personeli (Toplam Yatırım Miktarına Göre)**
  PersonnelModel? getPersonnelOfTheDay() {
    if (_personnelList.isEmpty) return null;
    _personnelList
        .sort((a, b) => b.totalInvestment.compareTo(a.totalInvestment));
    return _personnelList.first;
  }

  /// **📌 5 Saniyede Bir Veri Güncelleyen Stream**
  void _startStream() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      _fetchPersonnelFromJson();
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

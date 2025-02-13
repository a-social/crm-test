import 'package:crm_k/core/models/personel_model/personel_model.dart';

class PersonnelManager {
  final List<PersonnelModel> _personnelList = [];

  void addPersonnel(PersonnelModel personnel) {
    _personnelList.add(personnel);
    print('Personnel added: ${personnel.name}');
  }

  void removePersonnel(int id) {
    _personnelList.removeWhere((personnel) => personnel.id == id);
    print('Personnel with ID $id removed.');
  }

  PersonnelModel? getPersonnelById(int id) {
    return _personnelList.firstWhere(
      (personnel) => personnel.id == id,
      orElse: () => throw Exception('Personnel not found'),
    );
  }

  List<PersonnelModel> getAllPersonnel() {
    return List.unmodifiable(_personnelList);
  }

  void updatePersonnel(int id, PersonnelModel updatedPersonnel) {
    for (int i = 0; i < _personnelList.length; i++) {
      if (_personnelList[i].id == id) {
        _personnelList[i] = updatedPersonnel;
        print('Personnel updated: ${updatedPersonnel.name}');
        return;
      }
    }
    print('Personnel with ID $id not found.');
  }
}

import 'package:crm_k/core/models/admin_model/admin_model.dart';

class AdminManager {
  final List<AdminModel> _adminList = [];

  void addAdmin(AdminModel admin) {
    _adminList.add(admin);
    print('Admin added: ${admin.name}');
  }

  void removeAdmin(String email) {
    _adminList.removeWhere((admin) => admin.email == email);
    print('Admin with email $email removed.');
  }

  AdminModel? getAdminByEmail(String email) {
    try {
      return _adminList.firstWhere((admin) => admin.email == email);
    } catch (e) {
      print('Admin not found: $email');
      return null;
    }
  }

  List<AdminModel> getAllAdmins() {
    return List.unmodifiable(_adminList);
  }

  void updateAdmin(String email, AdminModel updatedAdmin) {
    for (int i = 0; i < _adminList.length; i++) {
      if (_adminList[i].email == email) {
        _adminList[i] = updatedAdmin;
        print('Admin updated: ${updatedAdmin.name}');
        return;
      }
    }
    print('Admin with email $email not found.');
  }

  bool adminExists(String email) {
    return _adminList.any((admin) => admin.email == email);
  }

  void clearAllAdmins() {
    _adminList.clear();
    print('All admins removed.');
  }
}

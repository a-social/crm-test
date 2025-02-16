//yerini değiştirmeyi unutma
import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _selectedUser;

  User? get selectedUser => _selectedUser;

  void selectUser(User user) {
    _selectedUser = user;
    notifyListeners(); // Sağ panelin güncellenmesi için haber ver
  }
}

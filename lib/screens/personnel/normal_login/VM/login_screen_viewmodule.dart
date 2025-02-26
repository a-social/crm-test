import 'package:crm_k/core/service/auth_provider.dart';
import 'package:crm_k/core/service/login_service.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginService _loginService;
  final AuthProvider _authProvider;
  bool isLoading = false;
  String? errorMessage;

  LoginViewModel(
      {required LoginService loginService, required AuthProvider authProvider})
      : _loginService = loginService,
        _authProvider = authProvider;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final token = await _loginService.login(email, password);

    if (token != null) {
      _authProvider.saveToken(token);
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      errorMessage = "Geçersiz giriş bilgileri!";
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

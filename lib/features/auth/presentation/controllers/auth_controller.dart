import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthController with ChangeNotifier {
  final AuthRepository _authRepository;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthController({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> loginClient(String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.loginClient(phone);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  Future<bool> loginStore(String phone, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.loginStore(phone, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

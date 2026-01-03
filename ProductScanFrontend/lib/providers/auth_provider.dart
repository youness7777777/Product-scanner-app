import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuth() async {
    _isAuthenticated = await _apiService.hasToken();
    if (_isAuthenticated) {
      try {
        _user = await _apiService.getMe();
      } catch (e) {
        _isAuthenticated = false;
        _user = null;
      }
    }
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    final data = await _apiService.register(name, email, password);
    _user = User.fromJson(data['user']);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final data = await _apiService.login(email, password);
    _user = User.fromJson(data['user']);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _apiService.logout();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}

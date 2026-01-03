import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.137.1:8000/api';

  String? _token;

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _token = token;
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token = null;
  }

  Map<String, String> _headers() {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _saveToken(data['access_token']);
      return data;
    } else {
      final error = jsonDecode(response.body);
      if (error['errors'] != null) {
        final errors = error['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first;
        throw Exception(firstError is List ? firstError[0] : firstError);
      }
      throw Exception(error['message'] ?? 'Registration failed');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['access_token']);
      return data;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    await _loadToken();
    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: _headers(),
    );
    await clearToken();
  }

  Future<User> getMe() async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  Future<Product> getProduct(String barcode) async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/products/$barcode'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Product not found');
    }
  }

  Future<void> addScan(String barcode) async {
    await _loadToken();
    await http.post(
      Uri.parse('$baseUrl/scans'),
      headers: _headers(),
      body: jsonEncode({'barcode': barcode}),
    );
  }

  Future<List<dynamic>> getScans() async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/scans'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch scans');
    }
  }

  Future<void> addFavorite(String barcode) async {
    await _loadToken();
    await http.post(
      Uri.parse('$baseUrl/favorites'),
      headers: _headers(),
      body: jsonEncode({'barcode': barcode}),
    );
  }

  Future<void> removeFavorite(String barcode) async {
    await _loadToken();
    await http.delete(
      Uri.parse('$baseUrl/favorites/$barcode'),
      headers: _headers(),
    );
  }

  Future<List<dynamic>> getFavorites() async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/favorites'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch favorites');
    }
  }

  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }
}

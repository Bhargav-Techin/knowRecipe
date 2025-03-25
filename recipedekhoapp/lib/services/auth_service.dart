import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class AuthService {
  final String baseUrl = 'https://knowrecipe-deployment-latest.onrender.com';
  final StorageService storageService = StorageService();

  // Login Method
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['jwt'] != null) {
      await storageService.saveJwt(data['jwt']);
    }

    return data;
  }

  // Register Method
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 && data['jwt'] != null) {
      await storageService.saveJwt(data['jwt']);
    }

    return data;
  }

  // Fetch User Profile
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    final token = await storageService.getJwt();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/api/user/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    await storageService.clearJwt();
  }

  // Check if User is Logged In
  Future<bool> isLoggedIn() async {
    return (await storageService.getJwt()) != null;
  }
}

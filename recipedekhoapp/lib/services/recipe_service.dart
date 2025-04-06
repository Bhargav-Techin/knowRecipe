import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class RecipeService {
  final String baseUrl = 'https://knowrecipe-deployment-latest.onrender.com';

  final BehaviorSubject<Map<String, dynamic>> recipeSubject =
      BehaviorSubject.seeded({'recipes': [], 'loading': false});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<dynamic>> getRecipes() async {
    recipeSubject.add({...recipeSubject.value, 'loading': true});
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse('$baseUrl/api/recipes'), headers: headers);
      final List<dynamic> recipes = jsonDecode(response.body);
      recipeSubject.add({'recipes': recipes, 'loading': false});
      return recipes;
    } catch (e) {
      recipeSubject.add({...recipeSubject.value, 'loading': false});
      throw Exception('Error fetching recipes: $e');
    }
  }

  Future<dynamic> getRecipeById(String id) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/recipes/$id'), headers: headers);
    return jsonDecode(response.body);
  }

  Future<dynamic> createRecipe(Map<String, dynamic> recipe) async {
    final headers = await _getHeaders();
    final response = await http.post(Uri.parse('$baseUrl/api/recipes'), headers: headers, body: jsonEncode(recipe));
    return jsonDecode(response.body);
  }

  Future<dynamic> updateRecipe(Map<String, dynamic> recipe) async {
    final headers = await _getHeaders();
    final response = await http.put(Uri.parse('$baseUrl/api/recipes/update/${recipe["id"]}'), headers: headers, body: jsonEncode(recipe));
    return jsonDecode(response.body);
  }

  Future<dynamic> deleteRecipe(String id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse('$baseUrl/api/recipes/$id'), headers: headers);
    print(response.runtimeType);
    return response;
  }

  Future<dynamic> likeRecipe(String id) async {
    final headers = await _getHeaders();
    final response = await http.put(Uri.parse('$baseUrl/api/recipes/$id/like'), headers: headers);
    return jsonDecode(response.body);
  }

  Future<dynamic> getLikes(String recipeId) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/recipes/$recipeId/likes'), headers: headers);
    return jsonDecode(response.body);
  }
}

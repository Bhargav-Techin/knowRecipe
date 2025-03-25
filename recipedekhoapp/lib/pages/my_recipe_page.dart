import 'package:flutter/material.dart';
import 'package:recipedekhoapp/services/recipe_service.dart';
import 'package:recipedekhoapp/services/auth_service.dart';
import 'package:recipedekhoapp/widgets/recipe_card.dart';
import 'package:recipedekhoapp/widgets/base_screen.dart';

class MyRecipesPage extends StatefulWidget {
  const MyRecipesPage({super.key});

  @override
  _MyRecipesPageState createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  final RecipeService recipeService = RecipeService();
  final AuthService authService = AuthService();

  int? userId;
  String? firstName;
  bool _isLoading = true;
  List<dynamic> _allRecipes = [];
  List<dynamic> _myRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadUserProfileAndRecipes();
  }

  Future<void> _loadUserProfileAndRecipes() async {
    setState(() => _isLoading = true);
    try {
      final userProfile = await authService.fetchUserProfile();
      if (userProfile != null) {
        userId = userProfile['id'];
        firstName = userProfile['fullName'].toString().split(" ").first; // Assign first name
      }
      final recipes = await recipeService.getRecipes();
      setState(() {
        _allRecipes = recipes;
        _myRecipes = _allRecipes.where((recipe) => recipe['user']['id'] == userId).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load recipes: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<Map<String, dynamic>?> _handleLike(String recipeId) async {
    try {
      return await recipeService.likeRecipe(recipeId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to like recipe: $e')),
      );
    }
    return null;
  }

  Future<void> _handleDelete(String recipeId) async {
    try {
      await recipeService.deleteRecipe(recipeId);
      setState(() {
        _allRecipes.removeWhere((recipe) => recipe['id'].toString() == recipeId);
        _myRecipes = _allRecipes.where((recipe) => recipe['createdBy'] == userId).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete recipe: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'RecipeDekho',
      onRefresh: _loadUserProfileAndRecipes,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "${firstName ?? 'User'}'s Recipes",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  child: _myRecipes.isEmpty
                      ? const Center(child: Text('No recipes added yet.'))
                      : ListView.builder(
                          itemCount: _myRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = _myRecipes[index];
                            return RecipeCard(
                              recipe: recipe,
                              userId: userId,
                              onLike: () => _handleLike(recipe['id'].toString()),
                              onDelete: () => _handleDelete(recipe['id'].toString()),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

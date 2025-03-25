import 'package:flutter/material.dart';
import 'package:recipedekhoapp/services/recipe_service.dart';
import 'package:recipedekhoapp/services/auth_service.dart';
import 'package:recipedekhoapp/widgets/recipe_card.dart';
import 'package:recipedekhoapp/widgets/base_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RecipeService recipeService = RecipeService();
  final AuthService authService = AuthService();

  int? userId;
  bool _isLoading = true;
  List<dynamic> _recipes = [];

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
      }
      final recipes = await recipeService.getRecipes();
      setState(() => _recipes = recipes);
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
      setState(() => _recipes.removeWhere((recipe) => recipe['id'].toString() == recipeId));
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
          : _recipes.isEmpty
              ? const Center(child: Text('No recipes available.'))
              : ListView.builder(
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      userId: userId,
                      onLike: () => _handleLike(recipe['id'].toString()),
                      onDelete: () => _handleDelete(recipe['id'].toString()),
                    );
                  },
                ),
    );
  }
}

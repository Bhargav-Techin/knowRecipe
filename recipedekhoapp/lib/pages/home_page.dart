import 'dart:ui'; // For blur effect
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load recipes: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<Map<String, dynamic>?> _handleLike(String recipeId) async {
    try {
      return await recipeService.likeRecipe(recipeId);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to like recipe: $e')));
    }
    return null;
  }

  Future<void> _handleDelete(String recipeId) async {
      setState(() => _isLoading = true);
    try {
      final respose = await recipeService.deleteRecipe(recipeId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(respose), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete recipe: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
      _loadUserProfileAndRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'RecipeDekho',
      onRefresh: _loadUserProfileAndRecipes,
      child:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF810081)),
              )
              : _recipes.isEmpty
              ? const Center(child: Text('No recipes available.'))
              : ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  final recipe = _recipes[_recipes.length - 1 - index];
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

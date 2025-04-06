import 'package:flutter/material.dart';
import 'package:recipedekhoapp/services/recipe_service.dart';
import 'package:recipedekhoapp/widgets/recipe_form.dart';

class CreateRecipeDialog extends StatefulWidget {
  final RecipeService recipeService;

  const CreateRecipeDialog({Key? key, required this.recipeService})
    : super(key: key);

  @override
  _CreateRecipeDialogState createState() => _CreateRecipeDialogState();
}

class _CreateRecipeDialogState extends State<CreateRecipeDialog> {
  bool _isLoading = false;

  void _handleCreate(
    BuildContext context,
    Map<String, dynamic> newRecipe,
  ) async {
    // Set loading state to true
    setState(() => _isLoading = true);

    try {
      final dynamic response = await widget.recipeService.createRecipe(
        newRecipe,
      );

      String message;
      if (response is Map<String, dynamic> && response.containsKey('message')) {
        message = response['message'].toString();
      } else if (response is String) {
        message = response;
      } else {
        message = 'Recipe created successfully';
      }

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );

      // Close dialog and return true to indicate successful creation
      Navigator.of(context).pop(true);
    } catch (e) {
      // Show error snackbar if recipe creation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating recipe: $e'),
          backgroundColor: Colors.red,
        ),
      );

      // Close dialog and return false to indicate failure
      Navigator.of(context).pop(false);
    } finally {
      // Ensure loading state is set to false
      setState(() => _isLoading = false);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [CircularProgressIndicator(color: Color(0xFF810081))],
          ),
        )
        : RecipeForm(
          title: 'Create Recipe',
          onSubmit: (newRecipe) => _handleCreate(context, newRecipe),
        );
  }
}

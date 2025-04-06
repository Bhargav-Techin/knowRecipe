import 'package:flutter/material.dart';
import 'package:recipedekhoapp/services/recipe_service.dart';
import 'package:recipedekhoapp/widgets/recipe_form.dart';

class UpdateRecipeDialog extends StatefulWidget {
  final RecipeService recipeService;
  final Map<String, dynamic> recipe;

  const UpdateRecipeDialog({
    Key? key,
    required this.recipeService,
    required this.recipe,
  }) : super(key: key);

  @override
  _UpdateRecipeDialogState createState() => _UpdateRecipeDialogState();
}

class _UpdateRecipeDialogState extends State<UpdateRecipeDialog> {
  bool _isLoading = false;

  void _handleUpdate(
    BuildContext context,
    Map<String, dynamic> updatedRecipe,
  ) async {
    final Map<String, dynamic> originalRecipe = widget.recipe;

    // Robust recipe type conversion
    if (updatedRecipe['recipeType'] is String) {
      // If it's already a string, use it directly
      updatedRecipe['recipeType'] = updatedRecipe['recipeType'];
    } else if (updatedRecipe['recipeType'] == 'true' || updatedRecipe['recipeType'] == true) {
      updatedRecipe['recipeType'] = 'Vegetarian';
    } else if (updatedRecipe['recipeType'] == 'false' || updatedRecipe['recipeType'] == false) {
      updatedRecipe['recipeType'] = 'Non-Vegetarian';
    } else {
      // Fallback to original recipe type or default
      updatedRecipe['recipeType'] = originalRecipe['recipeType'] ?? 'Vegetarian';
    }

    // Check for changes more comprehensively
    bool isChanged = updatedRecipe.keys.any((key) {
      // Skip comparing 'id' or other system-managed fields
      if (key == 'id') return false;
      
      // Compare values, handling potential null cases
      return (updatedRecipe[key] ?? '') != (originalRecipe[key] ?? '');
    });

    if (!isChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes detected!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Prevent multiple submissions
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // Ensure ID is included
      updatedRecipe['id'] = originalRecipe['id'];



      // Await and verify the result
      dynamic result = await widget.recipeService.updateRecipe(updatedRecipe);

      // Additional type checking for the result
      if (result == null) {
        throw Exception('No response from server');
      }

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recipe updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Close dialog only once, after success
      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      // Show error snackbar with more detailed error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating recipe: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Ensure loading state is reset
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Color(0xFF810081), // Match app's primary color
              ),
              SizedBox(height: 16),
              Text('Updating Recipe...'),
            ],
          ),
        )
        : RecipeForm(
          title: 'Update Recipe',
          initialRecipe: widget.recipe,
          onSubmit: (updatedRecipe) => _handleUpdate(context, updatedRecipe),
        );
  }
}
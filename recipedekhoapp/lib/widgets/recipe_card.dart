import 'package:flutter/material.dart';
import 'package:recipedekhoapp/pages/update_recipe_dialog.dart';
import 'package:recipedekhoapp/services/recipe_service.dart';

class RecipeCard extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final int? userId;
  final Future<Map<String, dynamic>?> Function() onLike;
  final VoidCallback? onDelete;
  final Future<void> Function()? onRefresh;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.userId,
    required this.onLike,
    this.onDelete,
    this.onRefresh,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  final RecipeService recipeService = RecipeService();
  late final Map<String, dynamic> recipe;
  bool isLiking = false;
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    isLiked = widget.recipe['likes'].contains(widget.userId);
    likeCount = widget.recipe['likes'].length;
  }

  Future<void> _toggleLike() async {
    if (isLiking) return;

    setState(() => isLiking = true);
    try {
      final updatedRecipe = await widget.onLike();
      if (updatedRecipe != null) {
        setState(() {
          isLiked = updatedRecipe['likes'].contains(widget.userId);
          likeCount = updatedRecipe['likes'].length;
        });
      }
    } catch (error) {
      debugPrint("Error in liking: $error");
    } finally {
      setState(() => isLiking = false);
    }
  }

  void openUpdateRecipeDialog(
    BuildContext context,
    RecipeService recipeService,
    Map<String, dynamic> recipe,
  ) async {
    bool _isLoading = false;
    setState(() => _isLoading = true); // Show loading before dialog opens

    final updatedRecipe = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) =>
              UpdateRecipeDialog(recipeService: recipeService, recipe: recipe),
    );

    setState(() => _isLoading = false); // Hide loading after dialog closes

    if (updatedRecipe != null) {
      setState(() {
        widget.recipe.clear();
        widget.recipe.addAll(updatedRecipe); // Update the UI with the new data
      });
      widget.onRefresh?.call(); // Refresh data if needed
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Confirm Delete",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Are you sure you want to delete this recipe?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color(0xFFFFABF3)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isOwner = widget.userId == widget.recipe['user']['id'];
    final bool isVeg = (widget.recipe['veg'] == true);

    return Card(
      color: Colors.black54,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.recipe['image'] ??
                    "https://cdn0.iconfinder.com/data/icons/social-messaging-ui-color-shapes/128/alert-triangle-red-1024.png",
                width: 140,
                height: 154,
                fit: BoxFit.cover,
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                ) {
                  // Display a default image if there is an error
                  return Image.network(
                    "https://cdn0.iconfinder.com/data/icons/social-messaging-ui-color-shapes/128/alert-triangle-red-1024.png",
                    width: 140,
                    height: 154,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.recipe['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: isVeg ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.only(right: 4),
                    child: Scrollbar(
                      thickness: 2, // Very thin scrollbar
                      radius: const Radius.circular(10),
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        child: Text(
                          widget.recipe['description'],
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _toggleLike,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF810081),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child:
                                    isLiking
                                        ? const SizedBox(
                                          width: 23,
                                          height: 23,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.red,
                                                ),
                                          ),
                                        )
                                        : Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite,
                                          color:
                                              isLiked
                                                  ? Colors.red
                                                  : Colors.black87,
                                        ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                likeCount.toString(),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isOwner) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF810081),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed:
                                () => openUpdateRecipeDialog(
                                  context,
                                  recipeService,
                                  widget.recipe,
                                ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF810081),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: _confirmDelete,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

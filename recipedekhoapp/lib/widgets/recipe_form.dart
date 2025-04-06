import 'package:flutter/material.dart';

class RecipeForm extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? initialRecipe;
  final Function(Map<String, dynamic>) onSubmit;

  const RecipeForm({Key? key, required this.title, this.initialRecipe, required this.onSubmit}) : super(key: key);

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _imageController;
  late TextEditingController _descriptionController;
  bool _isVeg = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialRecipe?['title'] ?? '');
    _imageController = TextEditingController(text: widget.initialRecipe?['image'] ?? '');
    _descriptionController = TextEditingController(text: widget.initialRecipe?['description'] ?? '');
    _isVeg = widget.initialRecipe?['veg'] ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

void _submitForm() {
  if (_formKey.currentState!.validate()) {
    widget.onSubmit({
      'title': _titleController.text.trim(),
      'image': _imageController.text.trim(), // Changed from 'image' to 'imageUrl'
      'description': _descriptionController.text.trim(),
      'veg': _isVeg,
      'recipeType': _isVeg ? 'Vegetarian' : 'Non-Vegetarian', // Convert boolean to string
    });
  }
}

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      floatingLabelStyle: const TextStyle(color: Color(0xFFFFABF3), fontWeight: FontWeight.bold),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: const UnderlineInputBorder(),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFABF3), width: 2)),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70, width: 1)),
      hintStyle: const TextStyle(color: Colors.white70),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<bool>(
                value: _isVeg,
                items: const [
                  DropdownMenuItem(value: true, child: Text('Vegetarian', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: false, child: Text('Non-Vegetarian', style: TextStyle(color: Colors.white))),
                ],
                onChanged: (value) => setState(() => _isVeg = value!),
                decoration: _inputDecoration('Select Recipe Type'),
                dropdownColor: Colors.black87,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Image URL'),
                validator: (value) => value!.isEmpty ? 'Enter an image URL' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Description'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Enter a description' : null,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                  ElevatedButton(onPressed: _submitForm, child: Text(widget.title)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

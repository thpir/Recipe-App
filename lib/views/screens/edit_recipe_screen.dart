import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/views/widgets/recipe_form.dart';

class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe;
  const EditRecipeScreen({required this.recipe, super.key});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Provider.of<RecipeController>(context, listen: false);
    controller.clearForm();
    controller.setRecipeForEditing(widget.recipe);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecipeController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil(
              (route) => route.isFirst,
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await controller.updateRecipe(widget.recipe.id!);
              if (context.mounted) Navigator.of(context).pop();
            },
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.indigo),
            ),
            child: const Text('Save'),
          )
        ],
      ),
      body: const SingleChildScrollView(
        child: RecipeForm(),
      ),
    );
  }
}

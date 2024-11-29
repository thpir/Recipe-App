import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/providers/recipe_form_provider.dart';
import 'package:recipe_app/providers/recipes_provider.dart';
import 'package:recipe_app/views/widgets/recipe_form.dart';

class CreateEditScreen extends StatelessWidget {
  final Recipe? recipe;
  const CreateEditScreen(this.recipe, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        if (recipe != null) {
          return RecipeFormProvider.fromRecipe(recipe!);
        } else {
          return RecipeFormProvider();
        }
      },
      child: Consumer<RecipeFormProvider>(
        builder: (context, recipeFormProvider, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(recipe == null ? 'Create Recipe' : 'Edit Recipe'),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () async {
                    await recipeFormProvider.saveRecipe(recipe?.id);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      Provider.of<RecipesProvider>(context, listen: false)
                          .fetchAllRecipes();
                    }
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
        },
      ),
    );
  }
}

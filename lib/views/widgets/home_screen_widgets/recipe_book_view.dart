import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/recipes_provider.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/recipe_grid_card.dart';

class RecipeBookView extends StatelessWidget {
  const RecipeBookView({super.key});

  @override
  Widget build(BuildContext context) {
    final recipesProvider = Provider.of<RecipesProvider>(context);
    var allRecipes = recipesProvider.recipes
        .map((recipe) => RecipeGridCard(recipe: recipe))
        .toList();
    return allRecipes.isEmpty
        ? Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 50,
                    color: Colors.indigo[200],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "You don't have any recipes yet!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/input-screen');
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.indigo),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: const Text("Add a recipe"))
                ],
              ),
            ),
          )
        : Stack(
          children: [
            if (recipesProvider.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Wrap(children: allRecipes,),
              ),
            )
          ],
        );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/recipes_provider.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/recipe_grid_card.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final recipesProvider = Provider.of<RecipesProvider>(context);
    var allFavoriteRecipes = recipesProvider.recipes
        .where((recipe) => recipe.favorite == 1)
        .map((recipe) => RecipeGridCard(recipe: recipe))
        .toList();
    return allFavoriteRecipes.isEmpty
        ? Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 50,
                    color: Colors.indigo[200],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "You don't have any favorites yet!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  child: Wrap(
                    children: allFavoriteRecipes,
                  ),
                ),
              )
            ],
          );
  }
}

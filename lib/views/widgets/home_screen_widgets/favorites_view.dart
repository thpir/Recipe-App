import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/home_screen_controller.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/recipe_grid_card.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/recipe_list_card.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecipeController>(context);
    final homeScreenController = Provider.of<HomeScreenController>(context);
    return FutureBuilder(
        future: controller.fetchAllRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var allRecipes = controller.allRecipes
                .where((element) => element.favorite == 1)
                .toList();
            if (allRecipes.isEmpty) {
              return Center(
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
              );
            }
            allRecipes.sort((a, b) => a.name.compareTo(b.name));
            if (homeScreenController.gridView) {
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: allRecipes.length,
                itemBuilder: (context, index) {
                  return RecipeGridCard(recipeId: allRecipes[index].id!);
                },
              );
            } else {
              return ListView.builder(
                  itemCount: allRecipes.length,
                  itemBuilder: (context, index) {
                    return RecipeListCard(recipeId: allRecipes[index].id!);
                  });
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.indigo,
              ),
            );
          }
        });
  }
}

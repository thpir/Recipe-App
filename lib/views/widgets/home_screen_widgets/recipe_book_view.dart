import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';
import 'package:recipe_app/globals.dart';
import 'package:recipe_app/views/widgets/recipe_card.dart';

class RecipeBookView extends StatelessWidget {
  const RecipeBookView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecipeController>(context);
    return FutureBuilder(
        future: controller.fetchAllRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var allRecipes = controller.allRecipes;
            if (allRecipes.isEmpty) {
              return Center(
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
                      const Text("You don't have any recipes yet!", style: TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/input-screen');
                          },
                          style: ButtonStyle(
                              elevation:
                                  MaterialStateProperty.all(defaultElevation),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.indigo),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: const Text("Add a recipe"))
                    ],
                  ),
                ),
              );
            }
            allRecipes.sort((a, b) => a.name.compareTo(b.name));
            return ListView.builder(
                itemCount: allRecipes.length,
                itemBuilder: (context, index) {
                  return RecipeCard(recipeId: allRecipes[index].id!);
                });
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

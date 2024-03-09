import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';
import 'package:recipe_app/views/widgets/recipe_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecipeController>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recipe App'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: controller.fetchAllRecipes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var allRecipes = snapshot.data;
                if (allRecipes != null) {
                  allRecipes.sort((a, b) => a.name.compareTo(b.name));
                  return ListView.builder(
                    itemCount: allRecipes.length,
                    itemBuilder: (context, index) {
                      return RecipeCard(recipe: allRecipes[index]);
                    });
                } else {
                  return const Center(
                    child: Text('No recipes found...'),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.indigo,
                  ),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/input-screen');
          },
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ));
  }
}

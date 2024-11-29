import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/providers/recipes_provider.dart';
import 'package:recipe_app/globals.dart';
import 'package:recipe_app/views/screens/recipe_screen.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/image_grid_placeholder.dart';

class RecipeGridCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeGridCard({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    final recipesProvider = Provider.of<RecipesProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: InkWell(
        onTap: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeScreen(
                  recipe: recipe),
            ),
          );
          //if (!context.mounted) return;
          if (context.mounted && result != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(result),
              duration: const Duration(seconds: 2),
            ));
          }
        },
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.indigo[100],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(defaultBorderRadius)),
            child: Stack(
              children: [
                recipe.photo !=
                        null
                    ? FutureBuilder(
                        future: recipesProvider.checkIfFileExists(recipe.photo!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data as bool
                                ? Image.file(
                                    File(recipe.photo!),
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover)
                                : const ImageGridPlaceholder();
                          } else {
                            return const CircularProgressIndicator();
                          }
                        })
                    : const ImageGridPlaceholder(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    color: Colors.black54,
                    child: Text(
                      recipe.name,
                      softWrap: true,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

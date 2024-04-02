import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';
import 'package:recipe_app/views/screens/recipe_screen.dart';

class RecipeCard extends StatelessWidget {
  final int recipeId;
  const RecipeCard({required this.recipeId, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecipeController>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeScreen(
                  recipeId: controller.allRecipes
                          .firstWhere((recipe) => recipe.id == recipeId)
                          .id ??
                      0),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 70,
            color: Colors.indigo[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                controller.allRecipes
                            .firstWhere((recipe) => recipe.id == recipeId)
                            .photo !=
                        null
                    ? FutureBuilder(
                        future: controller.checkIfFileExists(controller.allRecipes
                            .firstWhere((recipe) => recipe.id == recipeId)
                            .photo!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data as bool
                                ? Image.file(
                                    File(controller.allRecipes
                                        .firstWhere(
                                            (recipe) => recipe.id == recipeId)
                                        .photo!),
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover)
                                : Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.indigo[300],
                                    child: Center(
                                      child: Image.asset(
                                        "assets/launcher_icons/ic_launcher_foreground.png",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        })
                    : Container(
                        width: 70,
                        height: 70,
                        color: Colors.indigo[300],
                        child: Center(
                          child: Image.asset(
                            "assets/launcher_icons/ic_launcher_foreground.png",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(controller.allRecipes
                        .firstWhere((recipe) => recipe.id == recipeId)
                        .name),
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

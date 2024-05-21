import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';
import 'package:recipe_app/globals.dart';
import 'package:recipe_app/views/screens/recipe_screen.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/image_grid_placeholder.dart';

class RecipeGridCard extends StatelessWidget {
  final int recipeId;
  const RecipeGridCard({required this.recipeId, super.key});

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
        child: Container(
          width: double.infinity,
          height: double.infinity,
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
                controller.allRecipes
                            .firstWhere((recipe) => recipe.id == recipeId)
                            .photo !=
                        null
                    ? FutureBuilder(
                        future: controller.checkIfFileExists(controller
                            .allRecipes
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
                    color: Colors.white54,
                    child: Text(
                      controller.allRecipes
                      .firstWhere((recipe) => recipe.id == recipeId)
                      .name,
                      softWrap: true,
                      style: const TextStyle(
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


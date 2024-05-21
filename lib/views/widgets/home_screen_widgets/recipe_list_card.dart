import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';
import 'package:recipe_app/globals.dart';
import 'package:recipe_app/views/screens/recipe_screen.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/image_list_placeholder.dart';

class RecipeListCard extends StatelessWidget {
  final int recipeId;
  const RecipeListCard({required this.recipeId, super.key});

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
          height: 70,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(defaultBorderRadius),
                  bottomLeft: Radius.circular(defaultBorderRadius),
                ),
                child: controller.allRecipes
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
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover)
                                : const ImageListPlaceholder();
                          } else {
                            return const CircularProgressIndicator();
                          }
                        })
                    : const ImageListPlaceholder()
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    controller.allRecipes
                      .firstWhere((recipe) => recipe.id == recipeId)
                      .name,
                    style: const TextStyle(
                      fontSize: 16, 
                      overflow: TextOverflow.ellipsis
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

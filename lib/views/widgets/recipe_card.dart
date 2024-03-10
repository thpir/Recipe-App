import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/views/screens/recipe_screen.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeScreen(recipe: recipe),
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
                recipe.photo.isEmpty
                    ? Container(
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
                    )
                    : Image.memory(Uint8List.fromList(recipe.photo),
                    width: 70, height: 70, fit: BoxFit.cover),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(recipe.name),
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

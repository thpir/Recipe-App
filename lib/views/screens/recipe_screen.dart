import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';
import 'package:recipe_app/models/database_model.dart';
import 'package:recipe_app/models/ingredient.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/views/screens/edit_recipe_screen.dart';
import 'package:recipe_app/views/widgets/form_title.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeScreen extends StatefulWidget {
  final int recipeId;
  const RecipeScreen({required this.recipeId, super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool screenOn = false;

  @override
  void dispose() {
    super.dispose();
    KeepScreenOn.turnOff();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecipeController>(context);
    final Recipe recipe = controller.allRecipes
        .firstWhere((recipe) => recipe.id == widget.recipeId);
    Future<Widget> showUrlIfAvailable(String source) async {
      if (await canLaunchUrl(Uri.parse(source))) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Source: "),
              TextButton(
                onPressed: () => launchUrl(Uri.parse(source)),
                child: const Text(
                  "Link",
                  style: TextStyle(
                    color: Colors.indigo,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Source: ${recipe.source}"),
        );
      }
    }

    List<Widget> getIngredients() {
      List<Widget> ingredientList = [];
      for (var ingredient in jsonDecode(recipe.ingredients)) {
        var newIngredient = Ingredient.fromJson(ingredient);
        ingredientList.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4.0),
            child: Text(
                "${newIngredient.quantity} ${newIngredient.unit} ${newIngredient.name}"),
          ),
        );
      }
      return ingredientList.isEmpty
          ? [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                child: Text("No ingredients in recipe"),
              )
            ]
          : ingredientList;
    }

    List<Widget> getInstructions() {
      List<Widget> instructionsList = [];
      int index = 1;
      for (var instruction in jsonDecode(recipe.instructions)) {
        instructionsList.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$index. "),
                Expanded(child: Text(instruction)),
              ],
            ),
          ),
        );
        index++;
      }
      return instructionsList.isEmpty
          ? [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                child: Text("No instructions in recipe"),
              )
            ]
          : instructionsList;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  screenOn = !screenOn;
                  if (screenOn) {
                    KeepScreenOn.turnOn();
                  } else {
                    KeepScreenOn.turnOff();
                  }
                });
              },
              child: Text(
                screenOn ? "Screen on" : "Screen off",
                style: const TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              if (recipe.photo != null)
                FutureBuilder(
                    future: controller.checkIfFileExists(recipe.photo!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data as bool
                            ? Image.file(
                                File(recipe.photo!),
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Container();
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              Row(
                children: [
                  IconButton.filled(
                    onPressed: () async {
                      await DatabaseModel.likeRecipe(
                              widget.recipeId, recipe.favorite == 0 ? 1 : 0)
                          .then((_) async {
                        await controller
                            .fetchAllRecipes()
                            .then((_) => setState(() {}));
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black54),
                    ),
                    icon: recipe.favorite == 0
                        ? const Icon(Icons.favorite_border)
                        : const Icon(Icons.favorite),
                  ),
                  IconButton.filled(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditRecipeScreen(
                            recipe: recipe,
                          ),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black54),
                    ),
                    icon: const Icon(Icons.edit),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  IconButton.filled(
                    onPressed: () async {
                      await DatabaseModel.deleteItem('recipes', widget.recipeId)
                          .then((_) async {
                        Navigator.pop(context);
                        await controller.updateRecipeList();
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black54),
                    ),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            ]),
            if (recipe.preparationTime != 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text("Preparation time: ${recipe.preparationTime} minutes"),
              ),
            if (recipe.cookingTime != 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Cooking time: ${recipe.cookingTime} minutes"),
              ),
            if (recipe.portionSize != '0')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Portion size: ${recipe.portionSize}"),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Difficulty: ${recipe.difficulty}"),
            ),
            const FormTitle(text: "Ingredients:"),
            ...getIngredients(),
            const FormTitle(text: "Instructions:"),
            ...getInstructions(),
            if (recipe.source != null)
              FutureBuilder(
                  future: showUrlIfAvailable(recipe.source!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data as Widget;
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Loading source link..."),
                      );
                    }
                  })
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:recipe_app/models/ingredient.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/services/url_service.dart';
import 'package:recipe_app/utils/image_editor.dart';
import 'package:recipe_app/views/widgets/form_title.dart';
import 'package:recipe_app/views/widgets/recipe_screen_widgets/recipe_action_bar.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeScreen({required this.recipe, super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool screenOn = false;
  late Future<String> _filePath;

  @override
  void initState() {
    super.initState();
    _filePath = ImageEditor.getFullFilePath(widget.recipe.photo ?? '');
  }

  @override
  void dispose() {
    super.dispose();
    KeepScreenOn.turnOff();
  }

  @override
  Widget build(BuildContext context) {
    Future<Widget> showUrlIfAvailable(String source) async {
      if (await UrlService().isValidRecipeLink(source)) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Source: "),
              TextButton(
                onPressed: () => UrlService().openUrl(source, context),
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
          child: Text("Source: ${widget.recipe.source}"),
        );
      }
    }

    List<Widget> getIngredients() {
      List<Widget> ingredientList = [];
      for (var ingredient in jsonDecode(widget.recipe.ingredients)) {
        var newIngredient = Ingredient.fromJson(ingredient);
        ingredientList.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4.0),
            child: Text(
                "${newIngredient.quantity ?? ''} ${newIngredient.unit} ${newIngredient.name}"),
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
      for (var instruction in jsonDecode(widget.recipe.instructions)) {
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
        title: Text(widget.recipe.name),
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
                style: const TextStyle(color: Colors.indigo),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              if (widget.recipe.photo != null)
                FutureBuilder(
                  future: _filePath,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Container(
                            color: Theme.of(context).primaryColor,
                            width: double.infinity,
                            height:
                                MediaQuery.of(context).size.width * (9 / 16),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme!
                                  .secondaryContainer,
                              size: 50,
                            ));
                      }
                      var imageFile = File(snapshot.data!);
                      var bytes = imageFile.readAsBytesSync();
                      return Image.memory(
                        bytes,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width * (9 / 16),
                      );
                    }
                    return Container(
                        color: Theme.of(context).primaryColor,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width * (9 / 16),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .secondaryContainer,
                        ));
                  },
                ),
              RecipeActionBar(widget.recipe),
            ]),
            if (widget.recipe.preparationTime != 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text("Preparation time: ${widget.recipe.preparationTime} minutes"),
              ),
            if (widget.recipe.cookingTime != 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Cooking time: ${widget.recipe.cookingTime} minutes"),
              ),
            if (widget.recipe.portionSize != '0')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Portion size: ${widget.recipe.portionSize}"),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Difficulty: ${widget.recipe.difficulty}"),
            ),
            const FormTitle(text: "Ingredients:"),
            ...getIngredients(),
            const FormTitle(text: "Instructions:"),
            ...getInstructions(),
            if (widget.recipe.source != null)
              FutureBuilder(
                  future: showUrlIfAvailable(widget.recipe.source!),
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

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:recipe_app/services/db_service.dart';
import 'package:recipe_app/models/image_string.dart';
import 'package:recipe_app/models/recipe.dart';

class RecipeSaver {
  Future<String?> saveSingleRecipe(
      String recipeString, String recipeName) async {
    try {
      final String? externalStorageDirectory =
          await FilePicker.platform.getDirectoryPath();
      File file = File(path.join(
          externalStorageDirectory!,
          path.basename(
              "${removeSpecialCharactersAndSpaces(recipeName)}.recipe")));
      await file.writeAsString(recipeString);
      return 'Image saved successfully';
    } catch (e) {
      return 'Failed to save image';
    }
  }

  Future<String?> saveAllRecipes() async {
    final recipeList = await DbService.getTableData("recipes");
    var allRecipes =
        recipeList.map((recipe) => Recipe.fromJson(recipe)).toList();
    try {
      final String? externalStorageDirectory =
          await FilePicker.platform.getDirectoryPath();
      File file = File(path.join(
          externalStorageDirectory!,
          path.basename(
              "allRecipes${DateTime.now().millisecondsSinceEpoch}.recipe")));
      final sink = file.openWrite();
      try {
        for (Recipe recipe in allRecipes) {
          // Convert each Recipe object to a string and write to the file
          await recipe.recipeToExportFormat().then((value) {
            sink.write(value);
            sink.write('\n');
          });
        }
        return 'Recipes exported successfully';
      } finally {
        sink.close();
      }
    } catch (e) {
      return 'Failed to export recipes';
    }
  }

  Future<String?> importRecipes() async {
    String message = '';
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      if (result != null) {
        if (result.files.single.path!.endsWith('.recipe')) {
          final File file = File(result.files.single.path!);
          file
              .openRead()
              .transform(utf8.decoder)
              .transform(const LineSplitter())
              .forEach((line) async {
            try {
              // Convert each line of text to a Recipe object
              var result = Recipe.fromExportFormat(line);
              // Convert the image string to a Uint8List and save to the device
              String? imagePath;
              if (result.photo != null) {
                if (result.photo!.isNotEmpty) {
                  var image = ImageString().fromExportFormat(result.photo!);
                  imagePath = await saveImage(result.name, image);
                }
              }
              // Add the recipe to the database
              await importRecipe(result, imagePath);
            } catch (e) {
              message = 'Failed to import recipes: $e';
            }
          });
          message = 'Finished importing recipes';
        } else {
          message = 'Invalid file format';
        }
      }
    } catch (e) {
      message = 'Failed to import recipes: $e';
    }
    return message;
  }

  Future<void> importRecipe(Recipe recipeSource, String? imagePath) async {
    final Recipe recipe = Recipe(
      name: recipeSource.name,
      ingredients: recipeSource.ingredients,
      preparationTime: recipeSource.preparationTime,
      cookingTime: recipeSource.cookingTime,
      portionSize: recipeSource.portionSize,
      difficulty: recipeSource.difficulty,
      categories: recipeSource.categories,
      instructions: recipeSource.instructions,
      photo: imagePath,
      favorite: 0,
      source: recipeSource.source,
    );
    await DbService.insertItem("recipes", recipe.newRecipeToMap()).then((_) {});
  }

  Future<String?> saveImage(String recipeName, Uint8List image) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final filename =
        '${removeSpecialCharactersAndSpaces(recipeName)}${DateTime.now().millisecondsSinceEpoch}';
    final savedFile = File(path.join(documentsDirectory.path, filename));
    await savedFile.writeAsBytes(image);
    return savedFile.path;
  }

  String removeSpecialCharactersAndSpaces(String text) {
    final regex = RegExp(r'[^\w\s]');
    final lowercaseText = text.toLowerCase();
    return lowercaseText.replaceAll(regex, '');
  }
}

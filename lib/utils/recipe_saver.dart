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
    final recipeList = await DbService.readAll("recipes");
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

  Future<String?> pickRecipesToImport() async {
    String message = '';
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      if (result != null) {
        await readImportedFileAsRecipe(result.paths.first!);
      }
    } catch (e) {
      message = 'Failed to import recipes: $e';
    }
    return message;
  }

  Future<void> readImportedFileAsRecipe(String filePath) async {
    if (filePath.endsWith('.recipe')) {
      final File file = File(filePath);
      final List<String> recipeStrings = await file
          .openRead()
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .toList();
      final List<Recipe> recipes = recipeStrings
          .map((recipe) => Recipe.fromExportFormat(recipe))
          .toList();
      await Future.forEach(recipes, (recipe) async {
        String? photoPath;
        if (recipes[0].photo != null) {
          if (recipes[0].photo!.isNotEmpty) {
            var image = ImageString().fromExportFormat(recipes[0].photo!);
            photoPath = await saveImage(recipes[0].name, image);
            await importRecipe(recipes[0], photoPath);
          } else {
            await importRecipe(recipes[0], null);
          }
        } else {
          await importRecipe(recipes[0], null);
        }
      });
    }
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
    await DbService.insertItem("recipes", recipe.newRecipeToMap());
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

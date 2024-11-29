import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:recipe_app/services/db_service.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/utils/image_editor.dart';
import 'package:recipe_app/utils/recipe_saver.dart';

class RecipesProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  bool _isLoading = false;

  RecipesProvider() {
    fetchAllRecipes();
  }

  List<Recipe> get recipes => _recipes;

  bool get isLoading => _isLoading;

  Future<void> updateRecipeList() async {
    notifyListeners();
  }

  Future<void> fetchAllRecipes() async {
    _isLoading = true;
    notifyListeners();
    final tableData = await DbService.readAll("recipes");
    _recipes = tableData.map((recipe) => Recipe.fromJson(recipe)).toList();
    _recipes
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> checkIfFileExists(String path) async {
    return await File(path).exists();
  }

  Future<void> toggleRecipeAsFavorite(int id, int currentFavoriteStatus) async {
    await DbService.likeRecipe(id, currentFavoriteStatus == 1 ? 0 : 1);
    fetchAllRecipes();
  }

  Future<int> isRecipeMarkedAsFavorite(int id) async {
    final data = await DbService.read(DbService.RECIPES_TABLE, id);
    return Recipe.fromJson(data!).favorite;
  }

  Future<void> deleteRecipe(int id) async {
    await DbService.deleteItem(DbService.RECIPES_TABLE, id);
    String? photoUrl = recipes.firstWhere((recipe) => recipe.id == id).photo;
    if (photoUrl != null) {
      await ImageEditor().deleteImageFromStorage(photoUrl);
    }
    fetchAllRecipes();
  }

  Future<void> importSharedRecipes(SharedMediaFile file) async {
    final recipeSaver = RecipeSaver();
    await recipeSaver.readImportedFileAsRecipe(file.path).then((result) async {
      await fetchAllRecipes();
    });
    
  }
}

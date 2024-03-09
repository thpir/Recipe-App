import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/models/database_model.dart';
import 'package:recipe_app/models/ingredient.dart';
import 'package:recipe_app/models/recipe.dart';

class RecipeController extends ChangeNotifier {
  final BuildContext context;
  RecipeController({required this.context});
  Uint8List? image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController ingredientController = TextEditingController();
  final TextEditingController instructionController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  List<Ingredient> ingredients = [];
  List<String> instructions = [];
  List<String> categories = [];
  int prepTime = 0;
  int cookTime = 0;
  int portionSize = 0;
  String difficulty = "Easy";
  List<String> _availableCategories = [];
  // List<Recipe> _allRecipes = [];

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    amountController.dispose();
    unitController.dispose();
    ingredientController.dispose();
    instructionController.dispose();
    sourceController.dispose();
  }

  // // getting a copy of all the categories
  // List<Recipe> get allRecipes => _allRecipes;

  // Fetch all categories from the database
  Future<List<Recipe>> fetchAllRecipes() async {
    final recipeList = await DatabaseModel.getTableData("recipes");
    return recipeList.map((recipe) => Recipe.fromJson(recipe)).toList();
  }

  // Save recipe to the database
  Future<void> saveRecipe() async {
    if (nameController.text.isNotEmpty) {
      final Recipe recipe = Recipe(
        name: nameController.text,
        ingredients: jsonEncode(
            ingredients.map((ingredient) => ingredient.toJson()).toList()),
        preparationTime: prepTime,
        cookingTime: cookTime,
        portionSize: portionSize.toString(),
        difficulty: difficulty,
        categories: jsonEncode(categories),
        instructions: jsonEncode(instructions),
        photo: image != null ? image!.toList() : List<int>.empty(),
        favorite: 0,
        source: sourceController.text,
      );
      await DatabaseModel.insertItem("recipes", recipe.newRecipeToMap()).then((_) => clearForm());
      notifyListeners();
    } else {}
  }

  // Clearing the entire form
  void clearForm() {
    nameController.clear();
    amountController.clear();
    unitController.clear();
    ingredientController.clear();
    instructionController.clear();
    sourceController.clear();
    ingredients.clear();
    instructions.clear();
    categories.clear();
    prepTime = 0;
    cookTime = 0;
    portionSize = 0;
    difficulty = "Easy";
    image = null;
    notifyListeners();
  }

  // getting a copy of all the categories
  List<String> get availableCategories => _availableCategories;

  // Fetch all categories from the database
  Future<void> fetchCategories() async {
    final categoryList = await DatabaseModel.getTableData("categories");
    _availableCategories =
        categoryList.map((category) => category["name"].toString()).toList();
    notifyListeners();
  }

  // Add a new category to the database
  Future<void> addCategory(String newCategory) async {
    await DatabaseModel.insertItem("categories", {"name": newCategory});
    await fetchCategories();
  }

  // Adding the selected categories to the recipe
  void setCategories(List<String> newCategories) {
    categories = newCategories;
    notifyListeners();
  }

  /// Set the portion size of the recipe
  void setPortionSize(int size) {
    portionSize = size;
    notifyListeners();
  }

  /// Set the cook time of the recipe
  void setCookTime(int hour, int minute) {
    cookTime = hour * 60 + minute;
    notifyListeners();
  }

  /// Set the preparation time of the recipe
  void setPrepTime(int hour, int minute) {
    prepTime = hour * 60 + minute;
    notifyListeners();
  }

  /// Add an instruction to the recipe
  void addInstruction() {
    instructions.add(instructionController.text.isNotEmpty
        ? instructionController.text
        : "");
    instructionController.clear();
    notifyListeners();
  }

  /// Add an ingredient to the recipe
  void addIngredient() {
    ingredients.add(Ingredient(
      quantity: amountController.text.isNotEmpty
          ? int.parse(amountController.text)
          : 0,
      unit: unitController.text.isNotEmpty ? unitController.text : "",
      name:
          ingredientController.text.isNotEmpty ? ingredientController.text : "",
    ));
    amountController.clear();
    unitController.clear();
    ingredientController.clear();
    notifyListeners();
  }

  /// Add an image to the recipe
  void takeImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? takenImage = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (takenImage == null) return;
    image = await takenImage.readAsBytes();
    notifyListeners();
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    image = await pickedImage.readAsBytes();
    notifyListeners();
  }
}

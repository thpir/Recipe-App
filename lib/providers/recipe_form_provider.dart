import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:recipe_app/models/ingredient.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/services/db_service.dart';

class RecipeFormProvider extends ChangeNotifier {
  XFile? pickedImage;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController ingredientController = TextEditingController();
  final TextEditingController instructionController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  int isLiked = 0;
  bool permissionGranted = false;
  String? imagePath;
  List<Ingredient> ingredients = [];
  List<String> instructions = [];
  List<String> categories = [];
  int prepTime = 0;
  int cookTime = 0;
  int portionSize = 0;
  String difficulty = "Easy";
  List<String> _availableCategories = [];

  RecipeFormProvider() {
    fetchCategories();
  }

  RecipeFormProvider.fromRecipe(Recipe recipe) {
    setRecipeForEditing(recipe);
    fetchCategories();
  }

  setRecipeForEditing(Recipe recipe) async {
    nameController.text = recipe.name;
    ingredients = jsonDecode(recipe.ingredients).map<Ingredient>((ingredient) {
      return Ingredient.fromJson(ingredient);
    }).toList();
    instructions = jsonDecode(recipe.instructions).map<String>((instruction) {
      return instruction.toString();
    }).toList();
    prepTime = recipe.preparationTime ?? 0;
    cookTime = recipe.cookingTime ?? 0;
    portionSize = int.parse(recipe.portionSize ?? "0");
    difficulty = recipe.difficulty;
    categories = jsonDecode(recipe.categories).map<String>((category) {
      return category.toString();
    }).toList();
    sourceController.text = recipe.source ?? '';
    isLiked = recipe.favorite;
    imagePath = recipe.photo;
    pickedImage = imagePath != null
        ? await checkIfFileExists(imagePath!)
            ? XFile(imagePath!)
            : null
        : null;
  }

  Future<bool> checkIfFileExists(String path) async {
    return await File(path).exists();
  }

  Future<String?> saveImage(String recipeName) async {
    if (pickedImage != null) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final filename =
          '${recipeName.replaceAll(RegExp('[^A-Za-z0-9]'), '')}${DateTime.now().millisecondsSinceEpoch}';
      final savedFile = File(path.join(documentsDirectory.path, filename));
      await savedFile.writeAsBytes(await pickedImage!.readAsBytes());
      return savedFile.path;
    } else {
      return null;
    }
  }

  // Update the recipe in the database
  // Future<void> updateRecipe(int? id) async {
  //   if (nameController.text.isNotEmpty) {
  //     await saveImage(nameController.text).then((value) async {
  //       final Recipe recipe = Recipe(
  //         id: id,
  //         name: nameController.text,
  //         ingredients: jsonEncode(
  //             ingredients.map((ingredient) => ingredient.toJson()).toList()),
  //         preparationTime: prepTime,
  //         cookingTime: cookTime,
  //         portionSize: portionSize.toString(),
  //         difficulty: difficulty,
  //         categories: jsonEncode(categories),
  //         instructions: jsonEncode(instructions),
  //         photo: value,
  //         favorite: isLiked,
  //         source: sourceController.text,
  //       );
  //       await DbService.update(recipe).then((_) => clearForm());
  //       //await fetchAllRecipes().then((value) => notifyListeners());
  //     });
  //   }
  // }

  // Save recipe to the database
  Future<void> saveRecipe(int? id) async {
    if (nameController.text.isNotEmpty) {
      await saveImage(nameController.text).then((value) async {
        final Recipe recipe = Recipe(
          id: id,
          name: nameController.text,
          ingredients: jsonEncode(
              ingredients.map((ingredient) => ingredient.toJson()).toList()),
          preparationTime: prepTime,
          cookingTime: cookTime,
          portionSize: portionSize.toString(),
          difficulty: difficulty,
          categories: jsonEncode(categories),
          instructions: jsonEncode(instructions),
          photo: value,
          favorite: isLiked,
          source: sourceController.text,
        );
        if (id != null) {
          await DbService.update(recipe).then((_) {
            clearForm();
            notifyListeners();
          });
        } else {
          await DbService.insertItem("recipes", recipe.newRecipeToMap())
              .then((_) {
            clearForm();
            notifyListeners();
          });
        }
      });
    }
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
    isLiked = 0;
    pickedImage = null;
    imagePath = null;
  }

  // getting a copy of all the categories
  List<String> get availableCategories => _availableCategories;

  // Fetch all categories from the database
  Future<void> fetchCategories() async {
    final categoryList = await DbService.readAll("categories");
    _availableCategories =
        categoryList.map((category) => category["name"].toString()).toList();
    notifyListeners();
  }

  // Add a new category to the database
  Future<void> addCategory(String newCategory) async {
    await DbService.insertItem("categories", {"name": newCategory});
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
          : null,
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
  Future<void> takeImage() async {
    final ImagePicker picker = ImagePicker();
    pickedImage = await picker.pickImage(
      source: ImageSource.camera,
    );
    //if (takenImage == null) return;
    //image = await takenImage.readAsBytes();
    notifyListeners();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    //if (pickedImage == null) return;
    //image = await pickedImage.readAsBytes();
    notifyListeners();
  }

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
}

class Recipe {
  final int? id;
  final String name;
  final String ingredients;
  final int preparationTime;
  final int cookingTime;
  final String portionSize;
  final String difficulty;
  final String categories;
  final String instructions;
  final List<int> photo;
  final int favorite;
  final String source;

  Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.preparationTime,
    required this.cookingTime,
    required this.portionSize,
    required this.difficulty,
    required this.categories,
    required this.instructions,
    required this.photo,
    required this.favorite,
    required this.source,
  });
}
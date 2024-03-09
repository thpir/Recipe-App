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

  factory Recipe.fromJson(Map<String, dynamic> data) => Recipe(
        id: data['id'],
        name: data['name'],
        ingredients: data['ingredients'],
        preparationTime: data['preparation_time'],
        cookingTime: data['cooking_time'],
        portionSize: data['portion_size'],
        difficulty: data['difficulty'],
        categories: data['categories'],
        instructions: data['instructions'],
        photo: data['photo'] as List<int>,
        favorite: data['favorite'],
        source: data['source'],
      );

  Map<String, Object> newRecipeToMap() => {
        'name': name,
        'ingredients': ingredients,
        'preparation_time': preparationTime,
        'cooking_time': cookingTime,
        'portion_size': portionSize,
        'difficulty': difficulty,
        'categories': categories,
        'instructions': instructions,
        'photo': photo,
        'favorite': favorite,
        'source': source,
      };
}

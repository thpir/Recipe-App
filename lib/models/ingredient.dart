class Ingredient {
  final String name;
  final int quantity;
  final String unit;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> jsonString) {
    return Ingredient(
      name: jsonString['name'],
      quantity: jsonString['quantity'],
      unit: jsonString['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "quantity": quantity,
      "unit": unit,
    };
  }
}
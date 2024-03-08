import 'dart:convert';

class Ingredient {
  final String name;
  final int quantity;
  final String unit;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory Ingredient.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return Ingredient(
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
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
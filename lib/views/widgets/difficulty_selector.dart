import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/recipe_form_provider.dart';

enum Difficulty { easy, medium, hard }

class DifficultySelector extends StatefulWidget {
  const DifficultySelector({super.key});

  @override
  State<DifficultySelector> createState() => _DifficultySelectorState();
}

class _DifficultySelectorState extends State<DifficultySelector> {
  Difficulty? _difficulty = Difficulty.easy;
  @override
  Widget build(BuildContext context) {
    final recipeFormProvider = Provider.of<RecipeFormProvider>(context);
    return Column(
      children: [
        RadioListTile<Difficulty>(
          activeColor: Colors.indigo,
          title: const Text('Easy'),
          value: Difficulty.easy,
          groupValue: _difficulty,
          onChanged: (Difficulty? value) {
            setState(() {
              _difficulty = value;
              recipeFormProvider.difficulty = "Easy";
            });
          },
        ),
        RadioListTile<Difficulty>(
          activeColor: Colors.indigo,
          title: const Text('Medium'),
          value: Difficulty.medium,
          groupValue: _difficulty,
          onChanged: (Difficulty? value) {
            setState(() {
              _difficulty = value;
              recipeFormProvider.difficulty = "Medium";
            });
          },
        ),
        RadioListTile<Difficulty>(
          activeColor: Colors.indigo,
          title: const Text('Hard'),
          value: Difficulty.hard,
          groupValue: _difficulty,
          onChanged: (Difficulty? value) {
            setState(() {
              _difficulty = value;
              recipeFormProvider.difficulty = "Hard";
            });
          },
        ),
      ],
    );
  }
}

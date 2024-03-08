import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';

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
    final controller = Provider.of<RecipeController>(context);
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
              controller.difficulty = "Easy";
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
              controller.difficulty = "Medium";
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
              controller.difficulty = "Hard";
            });
          },
        ),
      ],
    );
  }
}

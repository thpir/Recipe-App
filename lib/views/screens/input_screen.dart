import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';
import 'package:recipe_app/views/widgets/recipe_form.dart';

class InputScreen extends StatelessWidget {
  static const String routeName = "/input-screen";
  const InputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecipeController>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Recipe'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () async {
                await controller.saveRecipe();
                if (context.mounted) Navigator.of(context).pop();
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ), 
              child: const Text('Save'),
            )
          ],
        ),
        body: const SingleChildScrollView(
          child: RecipeForm(),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';
import 'package:recipe_app/views/widgets/recipe_form.dart';

class InputScreen extends StatefulWidget {
  static const String routeName = "/input-screen";
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<RecipeController>(context, listen: false).clearForm();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecipeController>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Recipe'),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () async {
                await controller.saveRecipe().then((_) {
                  if (context.mounted) Navigator.of(context).pop();
                }); 
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.indigo),
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

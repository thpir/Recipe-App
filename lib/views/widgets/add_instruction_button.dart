import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/recipe_form_provider.dart';

class AddInstructionButton extends StatelessWidget {
  const AddInstructionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final recipeFormProvider = Provider.of<RecipeFormProvider>(context);

    void addInstructionDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Add instruction"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      minLines: 5,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.indigo,
                            width: 2,
                          ),
                        ),
                      ),
                      controller: recipeFormProvider.instructionController,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.indigo),
                  ),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    recipeFormProvider.addInstruction();
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.indigo),
                  ),
                  child: const Text("Add"),
                ),
              ],
            );
          });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: ElevatedButton(
        onPressed: addInstructionDialog,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.indigo),
          foregroundColor: WidgetStateProperty.all(Colors.white),
        ),
        child: const Text("Add Instruction"),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';

class AddInstructionButton extends StatelessWidget {
  const AddInstructionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecipeController>(context);

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
                      controller: controller.instructionController,
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
                    foregroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    controller.addInstruction();
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.indigo),
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
          backgroundColor: MaterialStateProperty.all(Colors.indigo),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: const Text("Add Instruction"),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/recipe_form_provider.dart';

class PortionSizeSelector extends StatefulWidget {
  const PortionSizeSelector({super.key});

  @override
  State<PortionSizeSelector> createState() => _PortionSizeSelectorState();
}

class _PortionSizeSelectorState extends State<PortionSizeSelector> {
  @override
  Widget build(BuildContext context) {
    final recipeFormProvider = Provider.of<RecipeFormProvider>(context);
    int portionSize = 0;

    void setPortionDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: StatefulBuilder(builder: (context, setState) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (portionSize > 0) {
                            portionSize--;
                          }
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.indigo),
                        foregroundColor:
                            WidgetStateProperty.all(Colors.white),
                      ),
                      child: const Text(
                        "-",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Text(
                      portionSize.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          portionSize++;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.indigo),
                        foregroundColor:
                            WidgetStateProperty.all(Colors.white),
                      ),
                      child: const Text(
                        "+",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                );
              }),
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
                    recipeFormProvider.setPortionSize(portionSize);
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.indigo),
                  ),
                  child: const Text("Set"),
                ),
              ],
            );
          });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              recipeFormProvider.portionSize != 0
                  ? "Portion size: ${recipeFormProvider.portionSize}"
                  : "Portion size: not set",
              style: const TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: setPortionDialog,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.indigo),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text("Set"),
            ),
          ]),
    );
  }
}

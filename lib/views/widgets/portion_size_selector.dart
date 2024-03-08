import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';

class PortionSizeSelector extends StatefulWidget {
  const PortionSizeSelector({super.key});

  @override
  State<PortionSizeSelector> createState() => _PortionSizeSelectorState();
}

class _PortionSizeSelectorState extends State<PortionSizeSelector> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecipeController>(context);
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
                            MaterialStateProperty.all(Colors.indigo),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
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
                            MaterialStateProperty.all(Colors.indigo),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
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
                    foregroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    controller.setPortionSize(portionSize);
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.indigo),
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
              controller.portionSize != 0
                  ? "Portion size: ${controller.portionSize}"
                  : "Portion size: not set",
              style: const TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: setPortionDialog,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.indigo),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text("Set"),
            ),
          ]),
    );
  }
}

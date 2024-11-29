import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/recipe_form_provider.dart';

class CookTimePicker extends StatefulWidget {
  const CookTimePicker({super.key});

  @override
  State<CookTimePicker> createState() => _CookTimePickerState();
}

class _CookTimePickerState extends State<CookTimePicker> {
  @override
  Widget build(BuildContext context) {
    final recipeFormProvider = Provider.of<RecipeFormProvider>(context);
    int hourValue = 0;
    int minuteValue = 0;

    void setDurationDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Row(
                children: [
                  StatefulBuilder(builder: (context, setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NumberPicker(
                          value: hourValue,
                          minValue: 0,
                          maxValue: 23,
                          onChanged: (value) {
                            setState(() {
                              hourValue = value;
                            });
                          },
                          infiniteLoop: false,
                        ),
                      ],
                    );
                  }),
                  const Text(
                    "h",
                    style: TextStyle(fontSize: 24),
                  ),
                  StatefulBuilder(builder: (context, setState) {
                    return NumberPicker(
                      value: minuteValue,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (value) {
                        setState(() {
                          minuteValue = value;
                        });
                      },
                      infiniteLoop: true,
                    );
                  }),
                  const Text(
                    "min",
                    style: TextStyle(fontSize: 24),
                  ),
                ],
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
                    recipeFormProvider.setCookTime(hourValue, minuteValue);
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
              recipeFormProvider.cookTime != 0
                  ? "Cooking time: ${recipeFormProvider.cookTime} min"
                  : "Cooking time: not set",
              style: const TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: setDurationDialog,
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

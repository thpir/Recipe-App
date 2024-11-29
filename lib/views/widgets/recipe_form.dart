import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/recipe_form_provider.dart';
import 'package:recipe_app/views/widgets/add_ingredient_button.dart';
import 'package:recipe_app/views/widgets/add_instruction_button.dart';
import 'package:recipe_app/views/widgets/cook_time_picker.dart';
import 'package:recipe_app/views/widgets/difficulty_selector.dart';
import 'package:recipe_app/views/widgets/portion_size_selector.dart';
import 'package:recipe_app/views/widgets/prep_time_picker.dart';
import 'package:recipe_app/views/widgets/form_image.dart';
import 'package:recipe_app/views/widgets/form_title.dart';
import 'package:recipe_app/views/widgets/tag_selector.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecipeFormProvider>(context);

    String getTagsList() {
      if (controller.categories.isEmpty) return "No tags selected";
      return controller.categories.join(", ");
    }

    List<Widget> getIngredientsList() {
      List<Widget> ingredientsList = [];
      if (controller.ingredients.isEmpty) return [];
      for (int i = 0; i < controller.ingredients.length; i++) {
        ingredientsList.add(
          ListTile(
              title: Text(
                "${controller.ingredients[i].quantity ?? ''} ${controller.ingredients[i].unit} ${controller.ingredients[i].name}",
                style: const TextStyle(fontSize: 16),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    controller.ingredients.removeAt(i);
                  });
                },
              )),
        );
      }
      return ingredientsList;
    }

    List<Widget> getInstructionsList() {
      List<Widget> instructionsList = [];
      if (controller.instructions.isEmpty) return [];
      for (int i = 0; i < controller.instructions.length; i++) {
        instructionsList.add(
          ListTile(
              leading: Text(
                "${i + 1}.",
                style: const TextStyle(fontSize: 16),
              ),
              title: Text(
                controller.instructions[i],
                style: const TextStyle(fontSize: 16),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    controller.instructions.removeAt(i);
                  });
                },
              )),
        );
      }
      return instructionsList;
    }

    return Column(
      children: [
        const FormImage(),
        const FormTitle(text: "Enter recipe name"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: TextField(
            controller: controller.nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.indigo,
                  width: 2,
                ),
              ),
              floatingLabelStyle: TextStyle(
                color: Colors.indigo,
              ),
              labelText: "Recipe name",
            ),
          ),
        ),
        const Divider(
          indent: 30,
          endIndent: 30,
        ),
        const FormTitle(text: "Add ingredients"),
        ...getIngredientsList(),
        const AddIngredientButton(),
        const Divider(
          indent: 30,
          endIndent: 30,
        ),
        const FormTitle(text: "Add instructions"),
        ...getInstructionsList(),
        const AddInstructionButton(),
        const Divider(
          indent: 30,
          endIndent: 30,
        ),
        const FormTitle(text: "Extra info"),
        const PrepTimePicker(),
        const CookTimePicker(),
        const PortionSizeSelector(),
        const Divider(
          indent: 30,
          endIndent: 30,
        ),
        const FormTitle(text: "Select difficulty"),
        const DifficultySelector(),
        const Divider(
          indent: 30,
          endIndent: 30,
        ),
        const FormTitle(text: "Select categories"),
        //...getSelectedTags(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            getTagsList(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const TagSelector(),
        const Divider(
          indent: 30,
          endIndent: 30,
        ),
        const FormTitle(text: "Provide source (optional)"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: TextField(
            controller: controller.sourceController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.indigo,
                  width: 2,
                ),
              ),
              floatingLabelStyle: TextStyle(
                color: Colors.indigo,
              ),
              labelText: "Source",
            ),
          ),
        ),
      ],
    );
  }
}

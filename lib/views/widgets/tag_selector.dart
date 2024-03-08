import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';
import 'package:recipe_app/models/category_model.dart';

class TagSelector extends StatefulWidget {
  const TagSelector({super.key});

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  final TextEditingController tagController = TextEditingController();
  late List<CategoryModel> allCategories;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await Provider.of<RecipeController>(context, listen: false)
        .fetchCategories()
        .then((_) {
      allCategories = Provider.of<RecipeController>(context, listen: false)
          .availableCategories
          .map((e) => CategoryModel(name: e))
          .toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecipeController>(context);

    bool categoriesAvailable() {
      for (CategoryModel category in allCategories) {
        if (category.name
            .toLowerCase()
            .contains(tagController.text.toLowerCase())) {
          return true;
        }
      }
      if (tagController.text.isEmpty) {
        return true;
      }
      return false;
    }

    List<Widget> getCategories() {
      List<Widget> categoriesToShow = [];
      for (CategoryModel category in allCategories) {
        if (category.name
            .toLowerCase()
            .contains(tagController.text.toLowerCase())) {
          categoriesToShow.add(StatefulBuilder(builder: (context, setState) {
            return CheckboxListTile(
              title: Text(category.name),
              activeColor: Colors.indigo,
              value: category.selected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    category.selected = true;
                  } else {
                    category.selected = false;
                  }
                });
              },
            );
          }));
        }
      }
      if (categoriesToShow.isNotEmpty) {
        return categoriesToShow;
      } else {
        return [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "No categories found...",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ];
      }
    }

    void addCategoriesDialog() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Select Categories"),
              content: SingleChildScrollView(
                child: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (value) {
                          setState(() {});
                        },
                        cursorColor: Colors.indigo,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Filter / create categories',
                          suffixIcon: InkWell(
                            child: const Icon(Icons.clear),
                            onTap: () {
                              setState(() {
                                tagController.clear();
                              });
                            },
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.indigo,
                              width: 2,
                            ),
                          ),
                        ),
                        controller: tagController,
                      ),
                      ...getCategories(),
                      categoriesAvailable()
                          ? Container()
                          : TextButton.icon(
                              onPressed: () async {
                                controller.addCategory(tagController.text);
                                await getData().then((_) {
                                  setState(() {});
                                });
                              },
                              icon: const Icon(Icons.add, color: Colors.indigo),
                              label: Text(
                                "Add ${tagController.text} to categories",
                                style: const TextStyle(
                                    color: Colors.indigo, fontSize: 16),
                              ))
                    ],
                  );
                }),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    List<String> selectedTags = [];
                    for (CategoryModel category in allCategories) {
                      if (category.selected) {
                        selectedTags.add(category.name);
                      }
                    }
                    controller.setCategories(selectedTags);
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  child: const Text("Done"),
                ),
              ],
            );
          });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: ElevatedButton(
        onPressed: addCategoriesDialog,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.indigo),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: const Text("Select / Unselect"),
      ),
    );
  }
}

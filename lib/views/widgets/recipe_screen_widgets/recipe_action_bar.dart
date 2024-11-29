import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/providers/recipes_provider.dart';
import 'package:recipe_app/utils/recipe_saver.dart';
import 'package:recipe_app/views/screens/create_edit_screen.dart';

class RecipeActionBar extends StatelessWidget {
  final Recipe recipe;
  const RecipeActionBar(this.recipe, {super.key});

  @override
  Widget build(BuildContext context) {
    final recipesProvider = Provider.of<RecipesProvider>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, left: 8),
          decoration: const BoxDecoration(
            color: Colors.black38,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Recipe'),
                    content: const Text('Are you sure you want to delete?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          await recipesProvider.deleteRecipe(recipe.id!);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        const Expanded(child: SizedBox()),
        Container(
          margin: const EdgeInsets.only(top: 8, right: 8),
          decoration: const BoxDecoration(
            color: Colors.black38,
            shape: BoxShape.circle,
          ),
          child: FavoriteButton(recipeId: recipe.id!),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, right: 8),
          decoration: const BoxDecoration(
            color: Colors.black38,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () async {
              recipe.recipeToExportFormat().then((value) async {
                var result =
                    await RecipeSaver().saveSingleRecipe(value, recipe.name);
                if (context.mounted) {
                  if (result != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Successfully saved recipe!'),
                      ),
                    );
                  }
                }
              });
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8, right: 8),
          decoration: const BoxDecoration(
            color: Colors.black38,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateEditScreen(recipe),
                ),
              );
            },
          ),
        ),
      ],
    );
    // return Row(
    //   children: [
    //     IconButton.filled(
    //       onPressed: () async {
    //         await DbService.likeRecipe(
    //                 widget.recipe.id!, widget.recipe.favorite == 0 ? 1 : 0)
    //             .then((_) async {
    //           await recipesProvider
    //               .fetchAllRecipes()
    //               .then((_) => setState(() {}));
    //         });
    //       },
    //       style: ButtonStyle(
    //         backgroundColor: WidgetStateProperty.all(Colors.black54),
    //       ),
    //       icon: widget.recipe.favorite == 0
    //           ? const Icon(Icons.favorite_border)
    //           : const Icon(Icons.favorite),
    //     ),
    //     IconButton.filled(
    //       onPressed: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => CreateEditScreen(widget.recipe),
    //           ),
    //         );
    //       },
    //       style: ButtonStyle(
    //         backgroundColor: WidgetStateProperty.all(Colors.black54),
    //       ),
    //       icon: const Icon(Icons.edit),
    //     ),
    //     IconButton.filled(
    //       onPressed: () async {
    //         widget.recipe.recipeToExportFormat().then((value) async {
    //           var result = await RecipeSaver()
    //               .saveSingleRecipe(value, widget.recipe.name);
    //           if (context.mounted) {
    //             if (result != null) {
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 SnackBar(
    //                   content: Text(result),
    //                 ),
    //               );
    //             } else {
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 const SnackBar(
    //                   content: Text('Successfully saved recipe!'),
    //                 ),
    //               );
    //             }
    //           }
    //         });
    //       },
    //       style: ButtonStyle(
    //         backgroundColor: WidgetStateProperty.all(Colors.black54),
    //       ),
    //       icon: const Icon(Icons.share),
    //     ),
    //     Expanded(
    //       flex: 1,
    //       child: Container(),
    //     ),
    //     IconButton.filled(
    //       onPressed: () async {
    //         await DbService.deleteItem('recipes', widget.recipe.id!)
    //             .then((_) async {
    //           if (context.mounted) {
    //             Navigator.pop(context);
    //           }
    //           await recipesProvider.updateRecipeList();
    //         });
    //       },
    //       style: ButtonStyle(
    //         backgroundColor: WidgetStateProperty.all(Colors.black54),
    //       ),
    //       icon: const Icon(
    //         Icons.delete_outline,
    //         color: Colors.red,
    //       ),
    //     ),
    //   ],
    // );
  }
}

class FavoriteButton extends StatefulWidget {
  final int recipeId;

  const FavoriteButton({
    required this.recipeId,
    super.key,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late Future<int> _isFavorite;

  @override
  void initState() {
    super.initState();
    updateState();
  }

  void updateState() {
    _isFavorite = Provider.of<RecipesProvider>(context, listen: false)
        .isRecipeMarkedAsFavorite(widget.recipeId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isFavorite,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data == 1
                ? IconButton(
                    onPressed: () async {
                      await Provider.of<RecipesProvider>(context, listen: false)
                          .toggleRecipeAsFavorite(
                              widget.recipeId, snapshot.data!);
                      updateState();
                    },
                    icon: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                    )
                : IconButton(
                    onPressed: () async {
                      await Provider.of<RecipesProvider>(context, listen: false)
                          .toggleRecipeAsFavorite(
                              widget.recipeId, snapshot.data!);
                      updateState();
                    },
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                  );
          } else {
            return const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
            );
          }
        });
  }
}

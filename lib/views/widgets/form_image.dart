import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/providers/recipe_form_provider.dart';

class FormImage extends StatefulWidget {
  const FormImage({super.key});

  @override
  State<FormImage> createState() => _FormImageState();
}

class _FormImageState extends State<FormImage> {
  @override
  Widget build(BuildContext context) {
    final recipeFormProvider = Provider.of<RecipeFormProvider>(context);
    void showImagePickerDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Choose image"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Take photo"),
                    onTap: () async {
                      await recipeFormProvider.takeImage().then((_) {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text("Choose from gallery"),
                    onTap: () async {
                      await recipeFormProvider.pickImage().then((_) {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                  ),
                ],
              ),
            );
          });
    }

    return Stack(
      children: [
        Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 200,
            width: double.infinity,
            color: Colors.black45,
            child: recipeFormProvider.pickedImage != null
                ? Image.file(
                    File(recipeFormProvider.pickedImage!.path),
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.photo,
                    size: 100,
                    color: Colors.white38,
                  )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: showImagePickerDialog,
                icon: const Icon(Icons.photo_camera),
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}

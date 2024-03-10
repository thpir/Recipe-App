import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:recipe_app/models/recipe.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeScreen({required this.recipe, super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool screenOn = false;

  @override
  void dispose() {
    super.dispose();
    KeepScreenOn.turnOff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  screenOn = !screenOn;
                  if (screenOn) {
                    KeepScreenOn.turnOn();
                  } else {
                    KeepScreenOn.turnOff();
                  }
                });
              },
              child: Text(
                screenOn ? "Screen on" : "Screen off",
                style: const TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                if (widget.recipe.photo.isNotEmpty) Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    height: 200,
                    width: double.infinity,
                    color: Colors.black45,
                    child: Image.memory(
                            Uint8List.fromList(widget.recipe.photo),
                            fit: BoxFit.cover,
                          ),)
                        
              ],
            ),
          ),
        ],
      ),
    );
  }
}

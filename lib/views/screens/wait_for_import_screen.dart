import 'package:flutter/material.dart';

class WaitForImportScreen extends StatelessWidget {
  const WaitForImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Recipe App',
          ),
          centerTitle: true,
        ),
        body: const Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  "Please wait while we import the recipe(s)...",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ])));
  }
}

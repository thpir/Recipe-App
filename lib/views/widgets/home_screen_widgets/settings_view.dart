import 'package:flutter/material.dart';
import 'package:recipe_app/utils/recipe_saver.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _isBusy = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text(
                  "Import/Export Recipes:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                setState(() {
                                  _isBusy = true;
                                });
                                var result = await RecipeSaver().importRecipes();
                                if (context.mounted) {
                                  if (result != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(result),
                                    ));
                                  }
                                }
                                setState(() {
                                  _isBusy = false;
                                });
                              },
                              icon: const Icon(Icons.download_rounded),
                              label: const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text("Import recipe(s)"),
                              ),
                              style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all(Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                setState(() {
                                  _isBusy = true;
                                });
                                var result = await RecipeSaver().saveAllRecipes();
                                if (context.mounted) {
                                  if (result != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(result),
                                    ));
                                  }
                                }
                                setState(() {
                                  _isBusy = false;
                                });
                              },
                              icon: const Icon(Icons.upload_rounded),
                              label: const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text("Export all recipes"),
                              ),
                              style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all(Colors.black),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isBusy)
          const Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}

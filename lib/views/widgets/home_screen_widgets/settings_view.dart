import 'package:flutter/material.dart';
import 'package:recipe_app/utils/file_saver.dart';

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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  onPressed: () async {
                    setState(() {
                      _isBusy = true;
                    });
                    var result = await FileSaver().importRecipes();
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
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  onPressed: () async {
                    setState(() {
                      _isBusy = true;
                    });
                    var result = await FileSaver().saveAllRecipes();
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
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
        if (_isBusy) const Center(
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}
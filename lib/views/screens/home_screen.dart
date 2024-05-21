import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/home_screen_controller.dart';
import 'package:recipe_app/globals.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/favorites_view.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/home_screen_navbar.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/recipe_book_view.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/settings_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Widget> _pages = <Widget>[
    RecipeBookView(),
    FavoritesView(),
    SettingsView()
  ];

  @override
  Widget build(BuildContext context) {
    final homeScreenController = Provider.of<HomeScreenController>(context);
    final controller = Provider.of<HomeScreenController>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recipe App'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: defaultElevation,
          actions: [
            if (homeScreenController.activePage == 0 || homeScreenController.activePage == 1) IconButton(
              icon: homeScreenController.gridView
                  ? const Icon(Icons.list_rounded)
                  : const Icon(Icons.apps_rounded),
              onPressed: () {
                homeScreenController.toggleView();
              },
            ),
          ],
        ),
        body: _pages[controller.activePage],
        bottomNavigationBar: const HomeScreenNavbar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/input-screen');
          },
          elevation: defaultElevation,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ));
  }
}

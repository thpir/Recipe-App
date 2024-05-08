import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/navigation_controller.dart';
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
    final controller = Provider.of<NavigationController>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recipe App'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: defaultElevation,
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

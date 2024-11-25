import 'package:flutter/material.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/favorites_view.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/recipe_book_view.dart';
import 'package:recipe_app/views/widgets/home_screen_widgets/settings_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Recipe App',
          ),
          centerTitle: true,
        ),
        body: [
          const RecipeBookView(),
          const FavoritesView(),
          const SettingsView()
        ][currentPageIndex],
        bottomNavigationBar: NavigationBar(
            onDestinationSelected: (value) {
              setState(() {
                currentPageIndex = value;
              });
            },
            selectedIndex: currentPageIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.menu_book_rounded),
                label: 'Recipe Book',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_rounded),
                label: 'Favorites',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/input-screen');
          },
          child: const Icon(Icons.add),
        ));
  }
}

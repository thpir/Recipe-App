import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:recipe_app/providers/recipes_provider.dart';
import 'package:recipe_app/views/screens/create_edit_screen.dart';
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
  late StreamSubscription _intentSubscription;
  final _sharedFiles = <SharedMediaFile>[];

  @override
  void initState() {
    super.initState();

    _intentSubscription =
        ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
      });
      processSharedFiles();
    });

    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        // Tell the library that we are done processing the intent.
        ReceiveSharingIntent.instance.reset();
      });
      processSharedFiles();
    });
  }

  Future<void> processSharedFiles() async {
    var recipesProvider = Provider.of<RecipesProvider>(context, listen: false);
    if  (_sharedFiles.isNotEmpty) {
      await recipesProvider.importSharedRecipes(_sharedFiles[0]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _intentSubscription.cancel();
  }

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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CreateEditScreen(null),
              ),
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}

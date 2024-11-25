import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/recipe_controller.dart';
import 'package:recipe_app/views/screens/home_screen.dart';
import 'package:recipe_app/views/screens/input_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<RecipeController>(
            create: (_) => RecipeController(context: context),
          ),
        ],
        child: MaterialApp(
          title: 'Recipe App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)
          ),
          home: const HomeScreen(),
          routes: {
            InputScreen.routeName: (ctx) => const InputScreen(),
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:recipe_app/views/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Recipe App',
      debugShowCheckedModeBanner: false,
      color: Colors.indigo,
      home: HomeScreen()
    );
  }
}

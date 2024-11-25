import 'package:flutter/material.dart';

class ImageGridPlaceholder extends StatelessWidget {
  const ImageGridPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.indigo,
      child: Center(
        child: Image.asset(
          "assets/launcher_icons/ic_launcher_foreground.png",
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

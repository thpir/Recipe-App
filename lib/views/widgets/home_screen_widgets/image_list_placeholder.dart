import 'package:flutter/material.dart';

class ImageListPlaceholder extends StatelessWidget {
  const ImageListPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      color: Colors.indigo[300],
      child: Center(
        child: Image.asset(
          "assets/launcher_icons/ic_launcher_foreground_v2.png",
          width: 70,
          height: 70,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

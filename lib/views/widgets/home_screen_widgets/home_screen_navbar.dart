import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/controllers/home_screen_controller.dart';

class HomeScreenNavbar extends StatefulWidget {
  const HomeScreenNavbar({super.key});

  @override
  State<HomeScreenNavbar> createState() => _HomeScreenNavbarState();
}

class _HomeScreenNavbarState extends State<HomeScreenNavbar> {
  static const List<IconData> icons = [
    Icons.menu_book_rounded,
    Icons.favorite_rounded,
    Icons.settings_rounded
  ];

  double getLineWidth(bool active) => active ? 32 : 0;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeScreenController>(context);
    return SafeArea(
        bottom: true,
        child: IntrinsicHeight(
          child: Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.indigo[100]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(icons.length, (index) {
                return Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          icons[index],
                          color: Colors.indigo,
                        ),
                        onPressed: () => controller.navigateToScreen(index),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        reverseDuration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: Container(
                          height: 4,
                          width: getLineWidth(index == controller.activePage),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
        ));
  }
}

import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  int activePage = 0;

  navigateToScreen(int newPage) {
    activePage = newPage;
    notifyListeners();
  }
}
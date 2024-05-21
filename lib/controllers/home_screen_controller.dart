import 'package:flutter/material.dart';

class HomeScreenController extends ChangeNotifier {
  int activePage = 0;
  bool gridView = false;

  navigateToScreen(int newPage) {
    activePage = newPage;
    notifyListeners();
  }

  toggleView() {
    gridView = !gridView;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:recipe_app/utils/messages.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlService {

  Future<bool> isValidRecipeLink(String url) async {
    try {
      return canLaunchUrl(Uri.parse(url));
    } catch (e) {
      return false;
    }
  }

  void openUrl(String url, BuildContext context) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      if (context.mounted) {
        showErrorMessage(context, 'Could not launch $url: $e');
      }
    }
  }
}
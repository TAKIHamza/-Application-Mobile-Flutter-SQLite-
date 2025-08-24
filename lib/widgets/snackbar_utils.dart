import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showSnackbar(BuildContext context, String message, bool isSuccess) {
    final Color successColor = Colors.green;
    final Color errorColor = Colors.red;

    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: isSuccess ? successColor : errorColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

import 'package:flutter/material.dart';

void showSuccessSnackbar(
    BuildContext context, Color backgroundColor, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ),
  );
}

void showErrorSnackbar(BuildContext context, Color backgroundColor, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ),
  );
}

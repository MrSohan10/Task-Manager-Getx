import 'package:flutter/material.dart';

void showSnackbar(BuildContext context,String title, [bool isError = false]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(title),
    backgroundColor: isError ? Colors.red : Colors.green,
  ));
}

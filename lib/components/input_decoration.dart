import 'package:flutter/material.dart';

InputDecoration inputDecoration(String? labelText, {String? hintText}) {
  return InputDecoration(
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1.5,
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1.5,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1.5,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.5,
      ),
    ),
    disabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1.5,
      ),
    ),
    labelText: labelText,
    hintText: hintText,
  );
}

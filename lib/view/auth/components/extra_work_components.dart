import 'package:flutter/material.dart';

TextFormField yourTextFormField(
    {required TextEditingController textController,
      required String hintTextFind,required TextInputAction textInputAction}) {
  return TextFormField(
    maxLength: null,
    textInputAction: textInputAction,
    controller: textController,
    style: TextStyle(color: Colors.amber.shade800),
    decoration: InputDecoration(
      hintText: hintTextFind,
      hintStyle: TextStyle(
        color: Colors.amber.shade800,
      ),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber.shade800)),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber.shade800),
      ),
    ),
  );
}
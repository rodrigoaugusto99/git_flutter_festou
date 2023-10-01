import 'package:flutter/material.dart';

class MyTextFormfield extends StatelessWidget {
  String? Function(String?)? validator;
  final controller;
  final String hintText;

  MyTextFormfield({
    Key? key,
    required this.controller,
    required this.hintText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(
              color: Colors.deepPurple,
              width: 2,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(
              color: Colors.purple,
              width: 4,
            ),
          ),
          fillColor: Colors.purple[50],
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.deepPurple),
        ),
      ),
    );
  }
}

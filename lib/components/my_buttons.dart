// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  VoidCallback onPressed;
  String text;
  MyButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size(300, 35),
          side: const BorderSide(
            width: 2,
            color: Color.fromRGBO(216, 0, 255, 1),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          )),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: Color.fromRGBO(216, 0, 255, 1),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black), // Cor do texto digitado
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey), // Cor do texto de dica
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey[300]!), // Cor da linha de baixo
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color:
                  Colors.purple[200]!), // Cor da linha de baixo quando focado
        ),
        contentPadding: const EdgeInsets.only(
            bottom: -11), // Distância entre o hintText e a linha inferior
      ),
    );
  }
}

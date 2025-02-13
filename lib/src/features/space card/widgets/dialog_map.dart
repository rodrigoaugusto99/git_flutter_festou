import 'package:flutter/material.dart';

class DialogMap extends StatelessWidget {
  const DialogMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'O local exato é fornecido depois da reserva',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

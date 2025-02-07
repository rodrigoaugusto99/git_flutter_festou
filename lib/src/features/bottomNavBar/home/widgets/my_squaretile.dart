import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final Function()? onTap;
  final String imagePath;
  const SquareTile({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Image.asset(
          imagePath,
        ),
      ),
    );
  }
}

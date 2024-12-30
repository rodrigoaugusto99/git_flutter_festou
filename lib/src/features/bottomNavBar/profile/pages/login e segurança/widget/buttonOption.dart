import 'package:flutter/material.dart';

class ButtonOption extends StatelessWidget {
  final String subtitle;
  final String textButton;
  final Widget? widget;
  final VoidCallback onTap;

  const ButtonOption({
    super.key,
    required this.subtitle,
    required this.textButton,
    this.widget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Row(
          children: [
            if (widget != null)
              Row(
                children: [
                  widget!,
                  const SizedBox(width: 10),
                ],
              ),
            Text(subtitle),
            const Spacer(),
            InkWell(
              onTap: onTap,
              child: Text(
                textButton,
                style: const TextStyle(
                  color: Color(0xFF4300B1),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

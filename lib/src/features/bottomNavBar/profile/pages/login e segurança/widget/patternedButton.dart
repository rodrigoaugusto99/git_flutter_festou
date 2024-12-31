import 'package:flutter/material.dart';

class PatternedButton extends StatelessWidget {
  final String title;
  final String textButton;
  final Widget? widget;
  final VoidCallback onTap;
  final bool buttonWithTextLink;

  const PatternedButton({
    super.key,
    required this.title,
    required this.textButton,
    this.widget,
    required this.onTap,
    this.buttonWithTextLink = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: buttonWithTextLink
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              child: Row(
                children: [
                  if (widget != null)
                    Row(
                      children: [
                        widget!,
                        const SizedBox(width: 10),
                      ],
                    ),
                  Text(title),
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
            )
          : InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            height: 20,
                            width: 20,
                            color: Colors.white,
                            child: widget),
                        const SizedBox(width: 10),
                        Text(title),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

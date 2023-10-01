import 'package:flutter/material.dart';

class MyTextbuttons extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String text2;
  final IconData icon;
  const MyTextbuttons(
      {super.key,
      required this.icon,
      required this.onPressed,
      required this.text,
      required this.text2});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0, left: 5.0),
            child: Text(
              text2,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5.0, right: 12.0),
            child: Divider(
              height: 2.0,
              color: Colors.black,
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

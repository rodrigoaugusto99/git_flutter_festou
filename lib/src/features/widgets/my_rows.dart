import 'package:flutter/material.dart';

class MyRows extends StatefulWidget {
  final String text;
  final Function()? onTap;
  const MyRows({super.key, required this.text, required this.onTap});

  @override
  State<MyRows> createState() => _MyRowsState();
}

class _MyRowsState extends State<MyRows> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.icecream),
                  Text(widget.text),
                ],
              ),
              const Icon(Icons.arrow_circle_right_rounded),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyRow extends StatefulWidget {
  final String text;
  final Widget icon1;
  final Function()? onTap;
  final Key? customKey;
  final double? height;
  final double? width;

  const MyRow({
    super.key,
    required this.text,
    required this.icon1,
    this.onTap,
    this.customKey,
    this.height,
    this.width,
  });

  @override
  State<MyRow> createState() => _MyRowState();
}

class _MyRowState extends State<MyRow> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: widget.customKey,
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: widget.height ?? 20,
                  width: widget.width ?? 20,
                  // color: Colors.blue,
                  child: widget.icon1,
                ),
                const SizedBox(width: 10),
                Text(widget.text),
              ],
            ),
            const Icon(Icons.keyboard_arrow_right_sharp),
          ],
        ),
      ),
    );
  }
}

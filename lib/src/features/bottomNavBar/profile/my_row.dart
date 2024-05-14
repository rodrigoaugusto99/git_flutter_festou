import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class MyRow extends StatelessWidget {
  final Function()? onTap;

  final String text;
  final Widget widget;
  const MyRow({
    super.key,
    this.onTap,
    required this.text,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    height: 20, width: 20, color: Colors.white, child: widget),
                const SizedBox(width: 10),
                Text(text),
              ],
            ),
            SvgPicture.asset('lib/assets/images/_sfaxx.svg'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MySliverToBoxAdapter extends StatelessWidget {
  final String text;
  const MySliverToBoxAdapter({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
          child: Text(
        text,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      )),
    );
  }
}

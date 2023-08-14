import 'package:flutter/material.dart';

class LocatarioSearch extends StatefulWidget {
  const LocatarioSearch({super.key});

  @override
  State<LocatarioSearch> createState() => _LocatarioSearchState();
}

class _LocatarioSearchState extends State<LocatarioSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Container(),
    );
  }
}

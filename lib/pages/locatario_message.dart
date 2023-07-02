import 'package:flutter/material.dart';

class LocatarioMessage extends StatefulWidget {
  const LocatarioMessage({super.key});

  @override
  State<LocatarioMessage> createState() => _LocatarioMessageState();
}

class _LocatarioMessageState extends State<LocatarioMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('message'),
      ),
      body: Container(),
    );
  }
}

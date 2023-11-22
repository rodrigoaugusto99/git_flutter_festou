import 'package:flutter/material.dart';

class Traducao extends StatefulWidget {
  const Traducao({super.key});

  @override
  State<Traducao> createState() => _TraducaoState();
}

class _TraducaoState extends State<Traducao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('traducao'),
      ),
      body: Container(),
    );
  }
}

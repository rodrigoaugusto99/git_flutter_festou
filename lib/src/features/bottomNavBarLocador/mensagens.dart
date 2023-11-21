import 'package:flutter/material.dart';

class Mensagens extends StatefulWidget {
  const Mensagens({super.key});

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensagns'),
      ),
      body: const Center(
          child: Text('Mensagens de clientes, suporte, equipe Festou, etc')),
    );
  }
}

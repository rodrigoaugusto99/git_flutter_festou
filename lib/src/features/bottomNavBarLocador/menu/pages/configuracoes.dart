import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/widgets/my_rows_config.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurações',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          MyRowsConfig(),
        ],
      ),
    );
  }
}

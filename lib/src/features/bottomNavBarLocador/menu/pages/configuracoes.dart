import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/widgets/my_rows_config.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:git_flutter_festou/src/models/user_with_images.dart';

class Configuracoes extends StatefulWidget {
  final UserWithImages userWithImages;
  const Configuracoes({super.key, required this.userWithImages});

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configurações',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          MyRowsConfig(
            userWithImages: widget.userWithImages,
          ),
        ],
      ),
    );
  }
}

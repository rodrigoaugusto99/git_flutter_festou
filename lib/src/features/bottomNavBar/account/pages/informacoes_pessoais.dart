import 'package:flutter/material.dart';

class InformacoesPessoais extends StatefulWidget {
  const InformacoesPessoais({super.key});

  @override
  State<InformacoesPessoais> createState() => _InformacoesPessoaisState();
}

class _InformacoesPessoaisState extends State<InformacoesPessoais> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          children: [
            const Text(
              'Informações pessoais',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            MyRow(
              title: 'Nome civil',
              subtitle: 'x',
              textButton: 'Editar',
            ),
            MyRow(
              title: 'Numero de telefone',
              subtitle: 'x',
              textButton: 'Adicionar',
            ),
            MyRow(
              title: 'Email',
              subtitle: 'x',
              textButton: 'Editar',
            ),
            MyRow(
              title: 'Endereço',
              subtitle: 'x',
              textButton: 'Editar',
            ),
            MyRow(
              title: 'Documento de identificação oficial',
              subtitle: 'x',
              textButton: 'Editar',
            ),
          ],
        ),
      ),
    );
  }

  Widget MyRow({
    required String title,
    required String subtitle,
    required String textButton,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(subtitle),
            ],
          ),
          Text(
            textButton,
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LoginSeguranca extends StatefulWidget {
  const LoginSeguranca({super.key});

  @override
  State<LoginSeguranca> createState() => _LoginSegurancaState();
}

class _LoginSegurancaState extends State<LoginSeguranca> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Login e Segurança',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'Login',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            MyRow(
              title: 'Senha',
              subtitle: 'Ultima atualização há \$x dias',
              textButton: 'Atualizar',
            ),
            const SizedBox(height: 30),
            const Text(
              'Contas sociais',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            MyRow(
              title: '\$Facebook',
              subtitle: '\$Conectado',
              textButton: 'Desconectar',
            ),
            const SizedBox(height: 30),
            const Text(
              'Conta',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            MyRow(
              title: 'Desativar sua conta',
              subtitle: '',
              textButton: 'Desativar',
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

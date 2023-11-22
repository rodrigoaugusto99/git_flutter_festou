import 'package:flutter/material.dart';

class LoginSeguranca extends StatefulWidget {
  const LoginSeguranca({super.key});

  @override
  State<LoginSeguranca> createState() => _LoginSegurancaState();
}

class _LoginSegurancaState extends State<LoginSeguranca> {
  bool isUpdatingPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                textButton: !isUpdatingPassword ? 'Atualizar' : 'Cancelar',
                onTap: () {
                  setState(() {
                    isUpdatingPassword = !isUpdatingPassword;
                  });
                },
              ),
              if (isUpdatingPassword) ...[
                // Container com os campos de atualização da senha
                Container(
                  child: Column(
                    children: [
                      const TextField(
                        decoration: InputDecoration(labelText: 'Senha Atual'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Esqueci minha senha'),
                        ],
                      ),
                      const SizedBox(height: 0),
                      const TextField(
                        decoration: InputDecoration(labelText: 'Nova Senha'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 0),
                      const TextField(
                        decoration:
                            InputDecoration(labelText: 'Confirmar Senha'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 0),
                      ElevatedButton(
                        onPressed: () {
                          // Implemente a lógica para "Alterar Senha"
                        },
                        child: const Text('Alterar Senha'),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 30),
              const Text(
                'Contas sociais',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              MyRow(
                title: '\$Facebook',
                subtitle: '\$Conectado',
                textButton: 'Desconectar',
                onTap: () {},
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
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyRow({
    required String title,
    required String subtitle,
    required String textButton,
    required final VoidCallback onTap,
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
          InkWell(
            onTap: onTap,
            child: Text(
              textButton,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

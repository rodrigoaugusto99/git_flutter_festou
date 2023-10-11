import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Central de Ajuda"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                "Como podemos ajudar?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Pesquisar tópicos de ajuda",
                ),
              ),
              const SizedBox(height: 16),
              const ExpansionTile(
                title: Text("Primeiro Tópico"),
                children: <Widget>[
                  ListTile(title: Text("Opção 1")),
                  ListTile(title: Text("Opção 2")),
                  // Adicione mais opções conforme necessário
                ],
              ),
              const ExpansionTile(
                title: Text("Segundo Tópico"),
                children: <Widget>[
                  ListTile(title: Text("Opção 1")),
                  ListTile(title: Text("Opção 2")),
                  // Adicione mais opções conforme necessário
                ],
              ),
              // Adicione mais tópicos expansíveis conforme necessário
            ],
          ),
        ),
      ),
    );
  }
}

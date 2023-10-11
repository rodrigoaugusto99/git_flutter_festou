import 'package:flutter/material.dart';

class QueroSerLocadorPage extends StatelessWidget {
  const QueroSerLocadorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Anunciante"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Quer ser um anunciante?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Para se tornar um anunciante, por favor, forneça as seguintes informações adicionais:",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: "CNPJ"),
            ),
            const TextField(
              decoration: InputDecoration(labelText: "Email Comercial"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Lógica para salvar as informações do anunciante
                print("Informações do anunciante salvas!");
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}

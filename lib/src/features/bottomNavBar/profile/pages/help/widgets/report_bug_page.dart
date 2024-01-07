import 'package:flutter/material.dart';

class ReportBugPage extends StatelessWidget {
  const ReportBugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatar um Problema"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                "Relate um Problema",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Obrigado por relatar um problema no nosso aplicativo de aluguel de salões de festa. Por favor, forneça o máximo de detalhes possível para nos ajudar a entender e resolver o problema. Isso nos ajuda a melhorar a experiência de todos os usuários.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nome",
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Sobrenome",
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Tipo de Problema",
                ),
                items: ["Problema de Reserva", "Problema de Pagamento", "Outro"]
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Detalhes do Problema",
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Número da Reserva (opcional)",
                ),
              ),
              const Text("Gravidade do Problema:"),
              RadioListTile(
                title: const Text(
                    "Impacta a minha reserva e não há solução alternativa."),
                value: "Crítico",
                groupValue: "Gravidade",
                onChanged: (value) {},
              ),
              RadioListTile(
                title: const Text(
                    "É um problema importante, mas há uma solução alternativa."),
                value: "Médio",
                groupValue: "Gravidade",
                onChanged: (value) {},
              ),
              RadioListTile(
                title: const Text("É um problema menor."),
                value: "Baixo",
                groupValue: "Gravidade",
                onChanged: (value) {},
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Resumo",
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Descrição Detalhada",
                ),
                maxLines: 5,
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para enviar o relatório de problema
                  // Você pode implementar o envio de relatórios para o seu serviço de suporte ou servidor.
                  Navigator.pop(context);
                },
                child: const Text("Enviar Relatório de Problema"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

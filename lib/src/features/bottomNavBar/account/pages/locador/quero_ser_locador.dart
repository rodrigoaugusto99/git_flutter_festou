import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/account/pages/locador/quero_ser_locador_vm.dart';

class QueroSerLocadorPage extends ConsumerWidget {
  QueroSerLocadorPage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  final cnpjEC = TextEditingController();
  final emailComercialEC = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queroSerLocadorVm = ref.watch(queroSerLocadorVmProvider.notifier);

    ref.listen(queroSerLocadorVmProvider, (_, state) {
      switch (state) {
        case QueroSerLocadorStateStatus.initial:
          break;
        case QueroSerLocadorStateStatus.success:
          Navigator.of(context).pop();
        case QueroSerLocadorStateStatus.error:
          Messages.showError('Erro ao registrar usuario', context);
      }
    });
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
            TextField(
              controller: cnpjEC,
              decoration: const InputDecoration(labelText: "CNPJ"),
            ),
            TextField(
              controller: emailComercialEC,
              decoration: const InputDecoration(labelText: "Email Comercial"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                queroSerLocadorVm.update(
                    user: user,
                    cnpj: cnpjEC.text,
                    emailComercial: emailComercialEC.text);
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}

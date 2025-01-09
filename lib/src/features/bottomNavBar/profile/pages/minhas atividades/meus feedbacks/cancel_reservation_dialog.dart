import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/exceptions/auth_exception.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';

class CancelReservationDialog extends StatefulWidget {
  const CancelReservationDialog({super.key});

  @override
  State<CancelReservationDialog> createState() =>
      _CancelReservationDialogState();
}

class _CancelReservationDialogState extends State<CancelReservationDialog> {
  final TextEditingController passwordController = TextEditingController();
  Future<void> validatePassword() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        errorText = 'Erro ao cancelar reserva';
        throw AuthError(message: 'Erro ao cancelar reserva');
      }
      // Reautentica o usuário antes de excluir a conta
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: passwordController.text,
      );
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw AuthError(message: 'Senha inválida!');
      }

      log('Erro ao cancelar reserva: ${e.code}, ${e.message}');
      throw AuthError(message: 'Erro ao cancelar reserva');
    } catch (e) {
      log('Erro desconhecido ao cancelar reserva: $e');
      throw AuthError(message: 'Erro ao cancelar reserva');
    }
  }

  String? errorText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cancelar Reserva"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Tem certeza que deseja cancelar a reserva? Por favor, insira sua senha para confirmar.",
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
                border: const OutlineInputBorder(),
                errorText: errorText,
                errorMaxLines: 2,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o diálogo sem cancelar
          },
          child: const Text("Voltar"),
        ),
        ElevatedButton(
          onPressed: () async {
            final password = passwordController.text;
            if (password.isEmpty) {
              errorText = 'Por favor, insira sua senha.';
              setState(() {});
            } else {
              try {
                await validatePassword();
                Navigator.of(context).pop();
                Messages.showSuccess('Reserva cancelada com sucesso!', context);
              } on AuthError catch (e) {
                errorText = e.message;
                setState(() {});
              }
              // Adicione aqui a lógica para verificar a senha e cancelar a reserva
            }
          },
          child: const Text("Confirmar"),
        ),
      ],
    );
  }
}

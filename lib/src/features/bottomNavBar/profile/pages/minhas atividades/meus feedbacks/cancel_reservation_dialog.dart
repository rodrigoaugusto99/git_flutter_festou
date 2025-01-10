import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/exceptions/auth_exception.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:git_flutter_festou/src/services/reserva_service.dart';

class CancelReservationDialog extends StatefulWidget {
  final ReservationModel reservation;
  const CancelReservationDialog({
    super.key,
    required this.reservation,
  });

  @override
  State<CancelReservationDialog> createState() =>
      _CancelReservationDialogState();
}

class _CancelReservationDialogState extends State<CancelReservationDialog> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  String? passwordErrorText;
  String? reasonErrorText;

  Future<void> validatePassword() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        passwordErrorText = 'Erro ao cancelar reserva';
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cancelar Reserva"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Tem certeza que deseja cancelar a reserva? Por favor, insira sua senha e o motivo do cancelamento para confirmar.",
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
                  errorText: passwordErrorText,
                  errorMaxLines: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 90,
              child: TextFormField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: "Motivo do Cancelamento",
                  border: const OutlineInputBorder(),
                  errorText: reasonErrorText,
                ),
                maxLength: 200, // Limite de caracteres para o motivo
              ),
            ),
          ],
        ),
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
            final reason = reasonController.text;

            // Validações
            bool hasError = false;
            if (password.isEmpty) {
              passwordErrorText = 'Por favor, insira sua senha.';
              hasError = true;
            } else {
              passwordErrorText = null;
            }

            if (reason.isEmpty) {
              reasonErrorText = 'Por favor, insira o motivo do cancelamento.';
              hasError = true;
            } else {
              reasonErrorText = null;
            }

            if (hasError) {
              setState(() {});
              return;
            }

            try {
              await validatePassword();
              Navigator.of(context).pop();
              await ReservaService()
                  .cancelReservation(widget.reservation.id!, reason);
              Messages.showSuccess('Reserva cancelada com sucesso!', context);
            } on AuthError catch (e) {
              passwordErrorText = e.message;
              setState(() {});
            }
          },
          child: const Text("Confirmar"),
        ),
      ],
    );
  }
}

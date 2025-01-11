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
  final TextEditingController inputController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  String? inputErrorText;
  String? reasonErrorText;
  bool isGoogleProvider = false;

  @override
  void initState() {
    super.initState();
    checkAuthProvider();
  }

  Future<void> checkAuthProvider() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final providerData = user.providerData;
      setState(() {
        isGoogleProvider =
            providerData.any((provider) => provider.providerId == 'google.com');
      });
    }
  }

  Future<void> validateInput() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        inputErrorText = 'Erro ao cancelar reserva';
        throw AuthError(message: 'Erro ao cancelar reserva');
      }

      if (isGoogleProvider) {
        if (inputController.text != user.email) {
          throw AuthError(message: 'E-mail inválido!');
        }
      } else {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: inputController.text,
        );
        await user.reauthenticateWithCredential(credential);
      }
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
            Text(
              isGoogleProvider
                  ? "Confirme seu e-mail para cancelar a reserva."
                  : "Tem certeza que deseja cancelar a reserva? Por favor, insira sua senha e o motivo do cancelamento para confirmar.",
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 90,
              child: TextFormField(
                controller: inputController,
                obscureText: !isGoogleProvider,
                decoration: InputDecoration(
                  labelText: isGoogleProvider ? "E-mail" : "Senha",
                  border: const OutlineInputBorder(),
                  errorText: inputErrorText,
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
                maxLength: 200,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Voltar"),
        ),
        ElevatedButton(
          onPressed: () async {
            final input = inputController.text;
            final reason = reasonController.text;

            bool hasError = false;
            if (input.isEmpty) {
              inputErrorText = isGoogleProvider
                  ? 'Por favor, insira seu e-mail.'
                  : 'Por favor, insira sua senha.';
              hasError = true;
            } else {
              inputErrorText = null;
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
              await validateInput();
              Navigator.of(context).pop();
              await ReservaService()
                  .cancelReservation(widget.reservation.id!, reason);
              Messages.showSuccess('Reserva cancelada com sucesso!', context);
            } on AuthError catch (e) {
              inputErrorText = e.message;
              setState(() {});
            }
          },
          child: const Text("Confirmar"),
        ),
      ],
    );
  }
}

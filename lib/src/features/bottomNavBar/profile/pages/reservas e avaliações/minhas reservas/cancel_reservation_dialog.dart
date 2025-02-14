import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/core/exceptions/auth_exception.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/login%20e%20seguran%C3%A7a/widget/passwordField.dart';
import 'package:festou/src/models/reservation_model.dart';
import 'package:festou/src/services/reserva_service.dart';
import 'package:lottie/lottie.dart';

class CancelReservationDialog extends StatefulWidget {
  final ReservationModel reservation;
  final VoidCallback? onReservationCancelled;
  const CancelReservationDialog({
    super.key,
    required this.reservation,
    this.onReservationCancelled,
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
        log('Erro ao cancelar reserva: ${e.code}, ${e.message}');
        throw AuthError(message: 'Senha inválida!');
      }
      log('Erro ao cancelar reserva: ${e.code}, ${e.message}');
      throw AuthError(message: 'Erro ao cancelar reserva');
    } on AuthError catch (e) {
      throw AuthError(message: e.message);
    } catch (e) {
      log('Erro desconhecido ao cancelar reserva: $e');
      throw AuthError(message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Lottie.asset(
                  'lib/assets/animations/warning_exit.json',
                  width: 80,
                  height: 80,
                  repeat: true,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Cancelar reserva',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              isGoogleProvider
                  ? "Confirme seu e-mail para cancelar a reserva."
                  : "Tem certeza que deseja cancelar a reserva? Insira sua senha e o motivo do cancelamento para confirmar.",
            ),
            const SizedBox(height: 16),
            SizedBox(
              //height: 90,
              child: isGoogleProvider
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: inputController,
                        decoration: InputDecoration(
                          labelText: "E-mail",
                          labelStyle: const TextStyle(
                            color: Color(0XFF4300B1),
                            fontSize: 13,
                          ),
                          border: const OutlineInputBorder(),
                          errorText: inputErrorText,
                        ),
                      ),
                    )
                  : PasswordField(
                      controller: inputController,
                      label: 'Senha',
                      errorText: inputErrorText,
                    ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              //height: 90,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    labelText: "Motivo do Cancelamento",
                    labelStyle: const TextStyle(
                      color: Color(0XFF4300B1),
                      fontSize: 13,
                    ),
                    border: const OutlineInputBorder(),
                    errorText: reasonErrorText,
                  ),
                  maxLength: 200,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
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

              // Atualiza a lista chamando o callback
              widget.onReservationCancelled?.call();

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

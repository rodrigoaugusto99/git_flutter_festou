import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:lottie/lottie.dart';

class LogoutDialog {
  static void showExitConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'lib/assets/animations/warning_exit.json',
                width: 100,
                height: 100,
                repeat: true,
              ),
              const SizedBox(height: 16),
              const Text(
                'Confirmação',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Deseja realmente sair do Festou?',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.invalidate(userFirestoreRepositoryProvider);
                ref.invalidate(userAuthRepositoryProvider);
                ref.read(logoutProvider.future);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}

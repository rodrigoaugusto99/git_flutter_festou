import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/bottomNavBarPage.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      isEmailVerified = currentUser.emailVerified;

      if (!isEmailVerified) {
        sendVerificationEmail();

        timer = Timer.periodic(const Duration(seconds: 3), (timer) {
          if (mounted) {
            checkEmailVerified();
          } else {
            // O widget foi descartado, cancela o timer
            timer.cancel();
          }
        });
      }
    }
  }

  Future<void> checkEmailVerified() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await currentUser.reload();
      if (mounted) {
        setState(() {
          isEmailVerified = currentUser.emailVerified;
        });
        if (isEmailVerified) timer?.cancel();
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.sendEmailVerification();

        if (mounted) {
          setState(() => canResendEmail = false);
        }

        await Future.delayed(const Duration(seconds: 5));

        if (mounted) {
          setState(() => canResendEmail = true);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const BottomNavBarPage()
      : Scaffold(
          appBar: AppBar(
            title: const Text('Valide o Email'),
          ),
          body: Column(
            children: [
              const Text('A verification email has been sent to your email.'),
              ElevatedButton(
                onPressed: canResendEmail ? sendVerificationEmail : null,
                child: const Text('Resend Email'),
              ),
              ElevatedButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        );
}

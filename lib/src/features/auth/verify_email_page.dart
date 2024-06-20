import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/bottomNavBarLocadorPage.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/bottomNavBarLocatarioPage.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  UserService userService = UserService();
  UserModel? userModel;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  Future<void> getUserModel() async {
    userModel = await userService.getCurrentUserModel();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserModel();
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
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      if (userModel == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        return userModel!.locador
            ? const BottomNavBarLocadorPage()
            : const BottomNavBarLocatarioPage();
      }
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Valide o Email'),
        ),
        body: Column(
          children: [
            const Text(
                'Um e-mail de validação foi enviado o e-mail cadastrado.'),
            ElevatedButton(
              onPressed: canResendEmail ? sendVerificationEmail : null,
              child: const Text('Reenviar e-mail'),
            ),
            ElevatedButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      );
    }
  }
}

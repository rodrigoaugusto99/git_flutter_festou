import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/bottomNavBarLocadorPage.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/bottomNavBarLocatarioPage.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/privacy_policy_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/service_terms_page.dart';
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

  Future<bool> checkPrivacyPolicyAcceptance() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final userQuery =
          await usersCollection.where('uid', isEqualTo: currentUser.uid).get();
      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        final userData = userDoc.data();
        return userData['privacy_policy_acceptance'] ?? false;
      }
    }
    return false;
  }

  Future<bool> checkServiceTermsAcceptance() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final userQuery =
          await usersCollection.where('uid', isEqualTo: currentUser.uid).get();
      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        final userData = userDoc.data();
        return userData['service_terms_acceptance'] ?? false;
      }
    }
    return false;
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
        return FutureBuilder<bool>(
          future: checkPrivacyPolicyAcceptance(),
          builder: (context, privacySnapshot) {
            if (privacySnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else {
              return FutureBuilder<bool>(
                future: checkServiceTermsAcceptance(),
                builder: (context, termsSnapshot) {
                  if (termsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    if (privacySnapshot.data == true &&
                        termsSnapshot.data == true) {
                      return userModel!.locador
                          ? const BottomNavBarLocadorPage()
                          : const BottomNavBarLocatarioPage();
                    } else if (privacySnapshot.data == false) {
                      return const PrivacyPolicyPage(duringLogin: true);
                    } else if (termsSnapshot.data == false) {
                      return const ServiceTermsPage(duringLogin: true);
                    } else {
                      return const Scaffold(
                        body: Center(
                          child: Text('Erro desconhecido. Tente novamente.'),
                        ),
                      );
                    }
                  }
                },
              );
            }
          },
        );
      }
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Valide o Email'),
        ),
        body: Column(
          children: [
            const Text(
                'Um e-mail de validação foi enviado ao e-mail cadastrado.'),
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

import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/features/bottomNavBar/bottom_navbar_locatario_page.dart';
import 'package:festou/src/features/bottomNavBar/profile/profile.dart';
import 'package:festou/src/features/bottomNavBarLocador/bottom_navbar_locador_page.dart';
import 'package:festou/src/features/space%20card/widgets/privacy_policy_page.dart';
import 'package:festou/src/features/space%20card/widgets/service_terms_page.dart';
import 'package:festou/src/helpers/constants.dart';
import 'package:festou/src/models/user_model.dart';
import 'package:festou/src/services/user_service.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

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
    if (mounted) {
      setState(() {});
    }
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
    if (isTest) return;
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
    if (isTest) {
      // return const BottomNavBarLocatarioPage();
      return const Profile();
    }
    if (isEmailVerified) {
      return FutureBuilder<bool>(
          future: checkPrivacyPolicyAcceptance(),
          builder: (context, privacySnapshot) {
            return FutureBuilder<bool>(
              future: checkServiceTermsAcceptance(),
              builder: (context, termsSnapshot) {
                if (privacySnapshot.data == true &&
                    termsSnapshot.data == true) {
                  return Scaffold(
                      backgroundColor: Colors.amber,
                      body: userModel!.locador
                          ? const BottomNavBarLocadorPage()
                          : const BottomNavBarLocatarioPage());
                } else if (privacySnapshot.data == false) {
                  return const Scaffold(
                      body: PrivacyPolicyPage(duringLogin: true));
                } else if (termsSnapshot.data == false) {
                  return const Scaffold(
                      body: ServiceTermsPage(duringLogin: true));
                } else {
                  return const Scaffold(
                    backgroundColor: Colors.white,
                    body: CustomLoadingIndicator(),
                  );
                }
              },
            );
          });
    } else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Valide o e-mail',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                textAlign: TextAlign.center,
                'Um e-mail de validação foi enviado ao e-mail cadastrado.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 34,
              ),
              GestureDetector(
                onTap: canResendEmail ? sendVerificationEmail : null,
                child: Container(
                    alignment: Alignment.center,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff9747FF),
                          // ignore: use_full_hex_values_for_flutter_colors
                          Color(0xff44300b1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Text(
                      'Reenviar e-mail',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () => FirebaseAuth.instance.signOut(),
                child: Container(
                    alignment: Alignment.center,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff9747FF),
                          // ignore: use_full_hex_values_for_flutter_colors
                          Color(0xff44300b1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      );
    }
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';

Future<String?> createUserAuth() async {
  try {
    final test = DateTime.now().millisecondsSinceEpoch;
    final userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: '$test@test.com',
      password: '222222',
    );
    log('Usuário teste: ${userCredential.user?.uid}');
    return userCredential.user!.uid;
  } catch (e) {
    log('Erro ao registrar usuário teste: $e');
  }
  return null;
}

Future<void> createUserOnFirestore(UserModel user) async {
  await FirebaseFirestore.instance.collection('users').doc(user.id).set({
    "displayName": "test",
    "email": user.email,
    "fcmToken": "token_test",
  });
}

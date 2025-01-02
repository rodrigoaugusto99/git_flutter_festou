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

Future<void> createUserOnFirestore(String userId) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).set({
    "assinatura":
        "data:image/png;base64,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",
    "avatar_url":
        "https://firebasestorage.googleapis.com/v0/b/flutterfestou.appspot.com/o/avatar%2F4mtW1VsILgUvDUKCWrNtkTJT3mf1%2Fimagem_avatar.jpg?alt=media&token=b5081169-5023-48df-8ca8-3f78c776867f",
    "cnpj": "22.222.222/2222-22",
    "cpf": "111.111.111-11",
    "email": "rodrigoaugusto051@gmail.com",
    "fantasy_name": "22222222",
    "last_seen": [
      "6e1f0cab-c91a-415f-b456-cdbebb964930",
      "bd52ae0f-3c09-4c61-a403-d857cf6bc703",
      "d1e75a4e-2376-47d2-a25b-0b7f2deeb69d",
      "9829d35c-381a-4eb3-9020-4675011e4996",
      "9833ecfa-9efc-4e8e-8e66-65c5c0dfd8a1",
      "b771be01-4d0e-4fb3-8306-4f553eef06f1",
      "5a31f5f6-c294-4d0a-8be7-bebd6e4b3ec7",
      "5678a443-7f0a-4220-8339-43638995a91b",
      "35b1ce97-5bb6-4a1c-991f-446aee92621e"
    ],
    "locador": false,
    "name": "rodrigo gmail",
    "notifications": 0,
    "privacy_policy_acceptance": true,
    "service_terms_acceptance": true,
    "spaces_favorite": [
      "9829d35c-381a-4eb3-9020-4675011e4996",
      "9833ecfa-9efc-4e8e-8e66-65c5c0dfd8a1",
      "d1e75a4e-2376-47d2-a25b-0b7f2deeb69d",
      "5a31f5f6-c294-4d0a-8be7-bebd6e4b3ec7",
      "b771be01-4d0e-4fb3-8306-4f553eef06f1",
      "bd52ae0f-3c09-4c61-a403-d857cf6bc703"
    ],
    "telefone": "ggcg",
    "uid": userId,
    "user_address": {"bairro": "", "cep": "", "cidade": "", "logradouro": ""}
  });
}

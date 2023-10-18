import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';

import 'package:git_flutter_festou/src/core/fp/either.dart';

import 'package:git_flutter_festou/src/core/fp/nil.dart';

import './user_firestore_repository.dart';

class UserFirestoreRepositoryImpl implements UserFirestoreRepository {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  @override
  Future<Either<RepositoryException, Nil>> registerUserInfos(
      ({
        User user,
        String name,
        String telefone,
        String cep,
        String logradouro,
        String bairro,
        String cidade,
      }) userData) async {
    try {
      QuerySnapshot querySnapshot =
          await users.where("uid", isEqualTo: userData.user.uid).get();

      if (querySnapshot.docs.length == 1) {
        DocumentReference userDocRef = querySnapshot.docs[0].reference;

//criando um mapa dessas informacoes
        Map<String, dynamic> newInfo = {
          'name': userData.name,
          'numero_de_telefone': userData.telefone,
          'user_address': {
            'cep': userData.cep,
            'logradouro': userData.logradouro,
            'bairro': userData.bairro,
            'cidade': userData.cidade,
          }
        };
        //jogando esse mapa no campo "user_infos" do documento referenciado
        //se o campo nao existir no firestore, é criado
        await userDocRef.update({
          'user_infos': newInfo,
        });

        log('Informações de usuário adicionadas com sucesso!');
      }
      return Success(nil);
    } catch (e) {
      log('Erro ao adicionar informações de usuário: $e');
      return Failure(RepositoryException(message: 'Erro ao cadastrar usuario'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> updateToLocador(
      ({
        User user,
        String cnpj,
        String emailComercial,
      }) userData) async {
    try {
      QuerySnapshot querySnapshot =
          await users.where("uid", isEqualTo: userData.user.uid).get();

      if (querySnapshot.docs.length == 1) {
        DocumentReference userDocRef = querySnapshot.docs[0].reference;

        await userDocRef.update({
          'cnpj': userData.cnpj,
          'emailComercial': userData.emailComercial,
          'userType': 'LOCADOR',
        });

        log('Informações de usuário adicionadas com sucesso!');
      }
      return Success(nil);
    } catch (e) {
      log('Erro ao adicionar informações de usuário: $e');
      return Failure(RepositoryException(message: 'Erro ao cadastrar usuario'));
    }
  }

  @override
  Future<void> createUserInFirestore(User user) async {
    final DocumentReference userDocRef = users.doc();

    Map<String, dynamic> userData = {
      'uid': user.uid,
      'email': user.email,
      'userType': 'LOCATARIO',
      //'user_infos': {},
      //'user_spaces': {},
    };
    await userDocRef.set(userData);
  }
}

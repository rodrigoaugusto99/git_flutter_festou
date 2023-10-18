import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';

import 'package:git_flutter_festou/src/core/fp/either.dart';

import 'package:git_flutter_festou/src/core/fp/nil.dart';

import './user_firestore_repository.dart';

class UserFirestoreRepositoryImpl implements UserFirestoreRepository {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  @override
  Future<Either<RepositoryException, Nil>> saveUser(
      ({
        String id,
        String email,
      }) userData) async {
    try {
// Crie um novo usuario com os dados fornecidos
      Map<String, dynamic> newUser = {
        'uid': userData.id,
        'email': userData.email,
        'userType': 'LOCATARIO',
        'nome': '',
        'telefone': '',
        'user_address': {
          'cep': '',
          'logradouro': '',
          'bairro': '',
          'cidade': '',
        }
      };

      // Insira o espaço na coleção 'spaces'
      await usersCollection.add(newUser);

      log('usuario criado na coleção users');

      return Success(nil);
    } catch (e) {
      log('Erro ao adicionar informações de usuário: $e');
      return Failure(RepositoryException(message: 'Erro ao cadastrar usuario'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> saveUserInfos(
      ({
        String userId,
        String name,
        String telefone,
        String cep,
        String logradouro,
        String bairro,
        String cidade,
      }) userData) async {
    try {
      log('userData: $userData');

      QuerySnapshot querySnapshot =
          await usersCollection.where("uid", isEqualTo: userData.userId).get();

      if (querySnapshot.docs.length == 1) {
        DocumentReference userDocRef = querySnapshot.docs[0].reference;
        Map<String, dynamic> newInfo = {
          'user_address': {
            'cep': userData.cep,
            'logradouro': userData.logradouro,
            'bairro': userData.bairro,
            'cidade': userData.cidade,
          },
          'name': userData.name,
          'telefone': userData.telefone,
        };

        // Atualize o documento do usuário com os novos dados
        await userDocRef.update(newInfo);

        log('Informações de usuário adicionadas com sucesso!');
        log('id do usuario alterado: ${userData.userId}');
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
      QuerySnapshot querySnapshot = await usersCollection
          .where("uid", isEqualTo: userData.user.uid)
          .get();

      if (querySnapshot.docs.length == 1) {
        DocumentReference userDocRef = querySnapshot.docs[0].reference;

        await userDocRef.update({
          'cnpj': userData.cnpj,
          'email_comercial': userData.emailComercial,
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
}

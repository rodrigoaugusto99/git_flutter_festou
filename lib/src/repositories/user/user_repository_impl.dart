import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/auth_exception.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<Either<AuthException, Nil>> login(
      String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success(nil);
    } on FirebaseAuthException catch (e, s) {
      log('Erro ao realizar login', error: e, stackTrace: s);
      return Failure(AuthError(message: 'Erro ao realizar login'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerUser(
      ({
        String email,
        String password,
      }) userData) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );
      User user = userCredential.user!;
      await createUserInFirestore(user);
      return Success(nil);
    } on Exception catch (e, s) {
      log('Erro ao cadastrar usuario', error: e, stackTrace: s);
      return Failure(RepositoryException(message: 'Erro ao cadastrar usuario'));
    }
  }

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUserInFirestore(User user) async {
    final DocumentReference userDocRef = users.doc();

    Map<String, dynamic> userData = {
      'uid': user.uid,
      'email': user.email,
      'user_infos': [],
      'user_spaces': [],
    };
    await userDocRef.set(userData);
  }

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

        await userDocRef.update({
          'user_infos.name': userData.name,
          'user_infos.numero_de_telefone': userData.telefone,
          'user_infos.user_address.cep': userData.cep,
          'user_infos.user_address.logradouro': userData.logradouro,
          'user_infos.user_address.bairro': userData.bairro,
          'user_infos.user_address.cidade': userData.cidade,
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

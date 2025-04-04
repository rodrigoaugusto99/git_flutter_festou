import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:festou/src/core/exceptions/auth_exception.dart';
import 'package:festou/src/core/fp/either.dart';
import 'package:festou/src/core/fp/nil.dart';

import 'package:festou/src/features/login/login_vm.dart';

import 'user_auth_repository.dart';

class UserAuthRepositoryImpl implements UserAuthRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;

//todo: especificar mensagens p cada erro
  UserAuthRepositoryImpl();
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

      final errorMessage = LoginVM().validateAll(e.code, email, password);

      return Failure(AuthError(message: errorMessage));
    }
  }

  /*@override
  Future<Either<AuthException, Nil>> loginWithGoogle() async {
    try {
      final userCredential = await AuthService().signInWithGoogle();

      final user = userCredential.user;

      userFirestoreRepository.saveUserWithGoogle();

      return Success(nil);
    } catch (e) {
      log('Erro ao adicionar informações de usuário no Firestore: $e');
      return Failure(
          AuthError(message: 'Erro ao cadastrar usuario no banco de dados'));
    }
  }*/

//nao usamos name e cpf msm, mas tem q botar por motivos extracurriculares
  @override
  Future<Either<AuthException, UserCredential>> registerUser(
      ({
        String email,
        String password,
        String name,
        String cpf,
      }) userData) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );
      return Success(userCredential);
    } on FirebaseAuthException catch (e, s) {
      return Failure(AuthError(message: 'erro: $e, stacktrace: $s'));
    } on Exception catch (e, s) {
      log('Erro ao cadastrar usuario', error: e, stackTrace: s);
      return Failure(AuthError(message: 'Erro desconhecido'));
    }
  }
}

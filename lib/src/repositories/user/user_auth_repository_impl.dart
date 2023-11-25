import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/auth_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/repositories/user/user_firestore_repository.dart';
import 'package:git_flutter_festou/src/services/auth_services.dart';
import 'user_auth_repository.dart';

class UserAuthRepositoryImpl implements UserAuthRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;

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
      return Failure(AuthError(message: 'Erro ao realizar login'));
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

  @override
  Future<Either<AuthException, Nil>> registerUser(
      ({
        String email,
        String password,
      }) userData) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );
      return Success(nil);
    } on Exception catch (e, s) {
      log('Erro ao cadastrar usuario', error: e, stackTrace: s);
      return Failure(AuthError(message: 'Erro ao cadastrar usuario'));
    }
  }
}

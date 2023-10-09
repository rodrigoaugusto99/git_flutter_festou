import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/auth_exception.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/features/test/write%20data/firestore_service.dart';
import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<Either<AuthException, Nil>> login(
      String email, String password) async {
    try {
      await FirestoreService.auth.signInWithEmailAndPassword(
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
      UserCredential userCredential =
          await FirestoreService.auth.createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );
      User user = userCredential.user!;
      await FirestoreService.createUserInFirestore(user);
      return Success(nil);
    } on Exception catch (e, s) {
      log('Erro ao cadastrar usuario', error: e, stackTrace: s);
      return Failure(RepositoryException(message: 'Erro ao cadastrar usuario'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerUserInfos(() userData) {
    // TODO: implement registerUserInfos
    throw UnimplementedError();
  }

  //depois arrumar para registerUserAuth e registerUserFirestore
  @override
  Future<Either<RepositoryException, Nil>> registerUserDocument(() userData) {
    // TODO: implement registerUserDocument
    throw UnimplementedError();
  }
}

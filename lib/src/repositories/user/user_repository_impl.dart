import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/auth_exception.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  // Autenticação de Usuário
  final FirebaseAuth _auth = FirebaseAuth.instance;

// Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<AuthException, Nil>> login(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success(nil);
    } on FirebaseAuthException catch (e, s) {
      log('Erro ao realizar login', error: e, stackTrace: s);
      return Failure(AuthError(message: 'Erro ao realizar login'));
    }
  }

  // Função para criar um documento de usuário no Firestore ao se cadastrar
  Future<void> createUserInFirestore(User user) async {
    final DocumentReference userDocRef =
        _firestore.collection('users').doc(user.uid);

    // Dados do usuário a serem armazenados no Firestore
    Map<String, dynamic> userData = {
      'uid': user.uid,
      'email': user.email,
    };

    await userDocRef.set(userData);
  }

  @override
  Future<Either<RepositoryException, Nil>> registerUser(
      ({
        String email,
        String password,
      }) userData) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
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
}

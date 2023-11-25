import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/auth_exception.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/repositories/user/user_firestore_repository_impl.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<Either<RepositoryException, Nil>> saveUserWithGoogle(User user) async {
// Verificar se o usuário possui um documento no Firestore
    try {
      final userDocument =
          await usersCollection.where('uid', isEqualTo: user.uid).get();

      if (userDocument.docs.isEmpty) {
        final userDataFirestore = (
          id: user.uid.toString(),
          email: user.email.toString(),
        );
        // Se o usuário não tiver um documento, salvar as informações no Firestore
        await saveUser(userDataFirestore);
      }
      return Success(nil);
    } catch (e) {
      log('Erro ao adicionar informações de usuário no Firestore: $e');
      return Failure(RepositoryException(
          message: 'Erro ao cadastrar usuario no banco de dados'));
    }
  }

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
      log('Erro ao adicionar informações de usuário no Firestore: $e');
      return Failure(RepositoryException(
          message: 'Erro ao cadastrar usuario no banco de dados'));
    }
  }

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<Either<AuthException, UserCredential>> signInWithGoogle() async {
    //begin interactive sign in process

    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      //obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      //create a new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      //final user = userCredential.user;

      final x = userCredential.user!;
      saveUserWithGoogle(x);

      return Success(userCredential);
    } catch (e) {
      log('Erro ao logar com google: $e');
      return Failure(AuthError(message: 'erro ao logar com google'));
    }
  }
}

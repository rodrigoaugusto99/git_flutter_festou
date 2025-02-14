import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/core/exceptions/auth_exception.dart';
import 'package:festou/src/core/exceptions/repository_exception.dart';
import 'package:festou/src/core/fp/either.dart';
import 'package:festou/src/core/fp/nil.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final BuildContext context;

  AuthService({
    required this.context,
  });
  /*como já veifiquei se o email ja esta cadastrado, entao nao preciso mais passar por essa verificacao, posso chamar o sveUser direto. */
  Future<Either<RepositoryException, Nil>> saveUserWithGoogle(User user) async {
    // Verificar se o usuário possui um documento no Firestore
    try {
      final userDocument =
          await usersCollection.where('uid', isEqualTo: user.uid).get();

      if (userDocument.docs.isEmpty) {
        final userDataFirestore = (
          id: user.uid.toString(),
          email: user.email.toString(),
          nome: user.displayName,
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
        String? nome,
      }) userData) async {
    try {
      // Crie um novo usuario com os dados fornecidos
      Map<String, dynamic> newUser = {
        'uid': userData.id,
        'email': userData.email,
        'userType': 'LOCATARIO',
        'nome': userData.nome ?? '',
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

  //todo:resolver email ja usado pra google - nao pode usar p email/senha
  //todo!:rsolver depois de criar conta com email/snha, se logar com google com o mesmmo mail, nao pode mais usar email/senha
  //todo!:resolver, se logar com email/senha, depois logar com google, se descinvuclar o google, nao consegue logar com email e senha
  //todo! bug de as vezes cadastrar por email/login e dar erro no primeiro login (usuario n encontrado)

  //se ja fez, boom. se não fez, chamar o onChngedProvider na page.
  //todo: logica para ver se o usuario já fez login com essa conta do google.(silenty)

  /*Future<String?> getGoogleUserEmail() async {
    try {
      // Inicialize o GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

      // Tente buscar as informações do perfil sem iniciar uma sessão completa
      final GoogleSignInAccount? googleUser =
          await googleSignIn.signInSilently();

      // Se já houver um usuário autenticado, obtenha o e-mail
      if (googleUser != null) {
        return googleUser.email;
      }

      return null; // Retorna nulo se não houver usuário autenticado
    } catch (e) {
      // Trate qualquer exceção que possa ocorrer durante a busca do perfil
      print('Erro ao buscar informações do perfil: $e');
      return null;
    }
  }*/

  Future<Either<AuthException, UserCredential>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ['profile', 'email']).signIn();

      if (googleUser == null) {
        return Failure(AuthError(message: 'Login com Google cancelado.'));
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return Success(userCredential);
    } catch (e) {
      log('Erro ao logar com Google: $e');
      return Failure(AuthError(message: 'Erro ao logar com Google: $e'));
    }
  }
}

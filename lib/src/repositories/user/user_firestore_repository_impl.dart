import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import './user_firestore_repository.dart';

class UserFirestoreRepositoryImpl implements UserFirestoreRepository {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser!;
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
      log('Erro ao adicionar informações de usuário no Firestore: $e');
      return Failure(RepositoryException(
          message: 'Erro ao cadastrar usuario no banco de dados'));
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
          'nome': userData.name,
          'telefone': userData.telefone,
        };

        // Atualize o documento do usuário com os novos dados
        await userDocRef.update(newInfo);

        log('Informações de usuário adicionadas com sucesso!');

        return Success(nil);
      } else if (querySnapshot.docs.isEmpty) {
        // Nenhum documento com o userId especificado foi encontrado
        log('Usuário não encontrado no firestore.');
        return Failure(RepositoryException(
            message: 'Usuário não encontrado no banco de dados.'));
      } else {
        // Mais de um documento com o mesmo userId foi encontrado (situação incomum)
        log('Mais de um documento com o mesmo userId foi encontrado no firestore.');
        return Failure(RepositoryException(
            message: 'Conflito de dados no bando de dados.'));
      }
    } catch (e) {
      log('Erro ao adicionar informações de usuário no firestore: $e');
      return Failure(RepositoryException(
          message: 'Erro ao atualizar informações de usuário.'));
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
      log('Erro ao atualizar userType locatario para locador: $e');
      return Failure(RepositoryException(
          message: 'Erro ao atualizar o usuário como Locador'));
    }
  }

  @override
  Future<Either<RepositoryException, UserModel>> getUser() async {
    try {
      final userDocument = await getUserDocument();

      final userData = userDocument.data() as Map<String, dynamic>;

      final UserModel userModel = UserModel(
        userData['email'] ?? '',
        userData['nome'] ?? '',
        userData['user_address']['cep'] ?? '',
        userData['user_address']['logradouro'] ?? '',
        userData['telefone'] ?? '',
        userData['user_address']['bairro'] ?? '',
        userData['user_address']['cidade'] ?? '',
        user.uid,
      );
      return Success(userModel);
    } catch (e) {
      log('Erro ao recuperar dados do usuario no firestore: $e');
      return Failure(
          RepositoryException(message: 'Erro ao atualizar o usuário: $e'));
    }
  }

  Future<DocumentSnapshot> getUserDocument() async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: user.uid).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0]; // Retorna o primeiro documento encontrado.
    }

    // Trate o caso em que nenhum usuário foi encontrado.
    throw Exception("Usuário não encontrado");
  }

  @override
  Future<Either<RepositoryException, Nil>> updatetUser(
      String text, String newText) async {
    try {
      final userDocument = await getUserDocument();

      if (text == 'nome') {
        // Atualize o campo 'nome' com o novo valor 'newText'
        await userDocument.reference.update({
          'nome': newText,
        });
      } else if (text == 'telefone') {
        // Lógica para atualizar o campo 'telefone'
        await userDocument.reference.update({
          'telefone': newText,
        });
      } else {
        // Lógica para outros campos, se necessário
        await userDocument.reference.update({
          'email': newText,
        });
      }

      // Retorna sucesso (Nil) se a atualização for bem-sucedida
      return Success(Nil());
    } catch (e) {
      // Trate exceções e retorne um erro personalizado se necessário
      return Failure(
          RepositoryException(message: 'Erro ao atualizar o usuário: $e'));
    }
  }
}

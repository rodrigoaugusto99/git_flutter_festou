import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:git_flutter_festou/src/repositories/images/images_storage_repository.dart';
import './user_firestore_repository.dart';

class UserFirestoreRepositoryImpl implements UserFirestoreRepository {
  final ImagesStorageRepository imagesStorageRepository;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  UserFirestoreRepositoryImpl({required this.imagesStorageRepository});

  /*@override
  Future<Either<RepositoryException, Nil>> saveUserWithGoogle() async {
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
  }*/

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
        },
        'avatar_url': '',
        'doc1_url': '',
        'doc2_url': '',
      };

      // Insira o usuario na coleção 'users'
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
      final user = FirebaseAuth.instance.currentUser!;
      final UserModel userModel = UserModel(
        userData['email'] ?? '',
        userData['nome'] ?? '',
        userData['user_address']['cep'] ?? '',
        userData['user_address']['logradouro'] ?? '',
        userData['telefone'] ?? '',
        userData['user_address']['bairro'] ?? '',
        userData['user_address']['cidade'] ?? '',
        user.uid,
        userData['doc1_url'] ?? '',
        userData['doc2_url'] ?? '',
        userData['avatar_url'] ?? '',
      );

      return Success(userModel);

      //return Success(userModel);
    } catch (e) {
      log('Erro ao recuperar dados do usuario no firestore: $e');
      return Failure(
          RepositoryException(message: 'Erro ao atualizar o usuário: $e'));
    }
  }

  /*Future<String> getInfo(String string) async {
    try {
      final userDocument = await getUserDocument();

      final userData = userDocument.data() as Map<String, dynamic>;

      final String x = userData[string] ?? '';

      return x;
    } catch (e) {
      log('Erro ao recuperar $string do usuario do firestore: $e');
      return 'deu erro';
    }
  }*/

  @override
  Future<Either<RepositoryException, UserModel>> getUserById(
      String userId) async {
    try {
      final userDocument = await getUserDocumentById(userId);

      final userData = userDocument.data() as Map<String, dynamic>;

      final UserModel userModel = UserModel(
        userData['email'] ?? '',
        userData['nome'] ?? '',
        userData['user_address']['cep'] ?? '',
        userData['user_address']['logradouro'] ?? '',
        userData['telefone'] ?? '',
        userData['user_address']['bairro'] ?? '',
        userData['user_address']['cidade'] ?? '',
        userId,
        userData['doc1_url'] ?? '',
        userData['doc2_url'] ?? '',
        userData['avatar_url'] ?? '',
      );
//gambiarra - colocando dados do firestore e do storage aqui
//esses swqitchs sao pra pegar os storags(cada um)

      return Success(userModel);
    } catch (e) {
      log('Erro ao recuperar dados do usuario no firestore: $e');
      return Failure(
          RepositoryException(message: 'Erro ao atualizar o usuário: $e'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> deleteUserDocument(User user) async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: user.uid).get();

    try {
      if (userDocument.docs.isNotEmpty) {
        userDocument.docs[0].reference.delete();
      } else {
        return Failure(RepositoryException(message: 'Erro impossivel'));
      }
      return Success(nil);
    } catch (e) {
      log(e.toString());
      // Trate exceções e retorne um erro personalizado se necessário
      return Failure(
          RepositoryException(message: 'Erro ao deletar o usuário: $e'));
    }
  }

  Future<DocumentSnapshot> getUserDocument() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userDocument =
        await usersCollection.where('uid', isEqualTo: user.uid).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0]; // Retorna o primeiro documento encontrado.
    }

    // Trate o caso em que nenhum usuário foi encontrado.
    throw Exception("Usuário não encontrado");
  }

  Future<DocumentSnapshot> getUserDocumentById(String userId) async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: userId).get();

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
      } else if (text == 'email') {
        // Lógica para outros campos, se necessário
        await userDocument.reference.update({
          'email': newText,
        });
      } else if (text == 'cep') {
        // Lógica para outros campos, se necessário
        await userDocument.reference.update({
          'user_address.cep': newText,
        });
      } else if (text == 'bairro') {
        // Lógica para outros campos, se necessário
        await userDocument.reference.update({
          'user_address.bairro': newText,
        });
      } else if (text == 'cidade') {
        // Lógica para outros campos, se necessário
        await userDocument.reference.update({
          'user_address.cidade': newText,
        });
      } else if (text == 'logradouro') {
        // Lógica para outros campos, se necessário
        await userDocument.reference.update({
          'user_address.logradouro': newText,
        });
      }

      // Retorna sucesso (Nil) se a atualização for bem-sucedida
      return Success(nil);
    } catch (e) {
      log(e.toString());
      // Trate exceções e retorne um erro personalizado se necessário
      return Failure(
          RepositoryException(message: 'Erro ao atualizar o usuário: $e'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> clearField(
      String fieldName, String userId) async {
    try {
      // Atualize o campo específico para uma string vazia ('') no Firestore
      final userDocument = await getUserDocumentById(userId);

      await userDocument.reference.update({
        fieldName: '',
      });

      log('Campo $fieldName apagado com sucesso para o usuário $userId');
      return Success(nil);
    } catch (e) {
      log(e.toString());
      log('Erro ao apagar esse campo: $e');
      // Trate exceções e retorne um erro personalizado se necessário
      return Failure(
          RepositoryException(message: 'Erro ao apagar esse campo: $e'));
    }
  }
}

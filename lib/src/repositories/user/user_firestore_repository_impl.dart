import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Festou/src/core/exceptions/repository_exception.dart';
import 'package:Festou/src/core/fp/either.dart';
import 'package:Festou/src/core/fp/nil.dart';
import 'package:Festou/src/models/user_model.dart';
import 'package:Festou/src/repositories/images/images_storage_repository.dart';
import 'package:Festou/src/services/user_service.dart';
import './user_firestore_repository.dart';

class UserFirestoreRepositoryImpl implements UserFirestoreRepository {
  final ImagesStorageRepository imagesStorageRepository;
  UserFirestoreRepositoryImpl({required this.imagesStorageRepository});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

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
        String name,
        String cpf,
      }) userData) async {
    try {
// Crie um novo usuario com os dados fornecidos
      Map<String, dynamic> newUser = {
        'uid': userData.id,
        'createdAt': FieldValue.serverTimestamp(),
        'email': userData.email,
        'fantasy_name': '',
        'locador': false,
        'name': userData.name,
        'cpf': userData.cpf,
        'telefone': '',
        'last_seen': [],
        'spaces_favorite': [],
        'user_address': {
          'cep': '',
          'logradouro': '',
          'bairro': '',
          'cidade': '',
        },
        'avatar_url': '',
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

  Future<Either<RepositoryException, Nil>> updateLocadorInfos({
    required String cpf,
    required String cnpj,
    required String empresaName,
    required String assinatura,
  }) async {
    try {
      final user = await UserService().getCurrentUserModel();

      QuerySnapshot querySnapshot =
          await usersCollection.where("uid", isEqualTo: user!.uid).get();

      if (querySnapshot.docs.length == 1) {
        DocumentReference userDocRef = querySnapshot.docs[0].reference;
        Map<String, dynamic> newInfo = {
          'cpf': cpf,
          'cnpj': cnpj,
          'empresaName': empresaName,
          'assinatura': assinatura,
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
  Future<Either<RepositoryException, Nil>> saveUserInfos(
      ({
        String userId,
        String fantasyName,
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
          'fantasy_name': userData.fantasyName,
          'name': userData.name,
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
  Future<Either<RepositoryException, UserModel>> getUser() async {
    try {
      final userDocument = await getUserDocument();

      final userData = userDocument.data() as Map<String, dynamic>;
      final user = FirebaseAuth.instance.currentUser!;
      UserModel userModel = UserModel.fromMap(userData);

      return Success(userModel);

      //return Success(userModel);
    } catch (e) {
      log('Erro ao recuperar dados do usuario no firestore: $e');
      return Failure(
          RepositoryException(message: 'Erro ao atualizar o usuário: $e'));
    }
  }

  @override
  Future<Either<RepositoryException, UserModel>> getUserById(
      String userId) async {
    try {
      final userDocument = await getUserDocumentById(userId);

      final userData = userDocument.data() as Map<String, dynamic>;

      UserModel userModel = UserModel.fromMap(userData);
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

      if (text == 'fantasyName') {
        // Atualize o campo 'fantasy_nome' com o novo valor 'newText'
        await userDocument.reference.update({
          'fantasy_name': newText,
        });
      } else if (text == 'name') {
        // Atualize o campo 'nome' com o novo valor 'newText'
        await userDocument.reference.update({
          'name': newText,
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

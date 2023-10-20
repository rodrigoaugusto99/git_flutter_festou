import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/features/home/my%20favorite%20spaces%20mvvm/my_favorite_spaces_vm.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/repositories/space/space_firestore_repository.dart';

class SpaceFirestoreRepositoryImpl implements SpaceFirestoreRepository {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Future<Either<RepositoryException, Nil>> saveSpace(
      ({
        String spaceId,
        String userId,
        String email,
        String name,
        String bairro,
        String cep,
        String cidade,
        String logradouro,
        String numero,
        List<String> selectedTypes,
        List<String> selectedServices,
        List<String> availableDays,
      }) spaceData) async {
    try {
      // Crie um novo espaço com os dados fornecidos
      Map<String, dynamic> newSpace = {
        'space_id': spaceData.spaceId,
        'user_id': spaceData.userId,
        'email_do_espaço': spaceData.email,
        'nome_do_espaço': spaceData.name,
        'cep': spaceData.cep,
        'logradouro': spaceData.logradouro,
        'numero': spaceData.numero,
        'bairro': spaceData.bairro,
        'cidade': spaceData.cidade,
        'selectedTypes': spaceData.selectedTypes,
        'selectedServices': spaceData.selectedServices,
        'availableDays': spaceData.availableDays,
      };

      // Insira o espaço na coleção 'spaces'
      await spacesCollection.add(newSpace);

      log('Informações de espaço adicionadas com sucesso!');
      return Success(Nil());
    } catch (e) {
      log('Erro ao adicionar informações de espaço: $e');
      return Failure(RepositoryException(message: 'Erro ao cadastrar espaço'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceModel>>> getAllSpaces() async {
    try {
      final spaceDocuments = await spacesCollection.get();
      final spaceModels = spaceDocuments.docs.map((spaceDocument) {
        //final spaceAddress = spaceDocument['space_address'];

        return SpaceModel(
          false,
          spaceDocument['space_id'],
          spaceDocument['user_id'],
          spaceDocument['email_do_espaço'],
          spaceDocument['nome_do_espaço'],
          spaceDocument['cep'],
          spaceDocument['logradouro'],
          spaceDocument['numero'],
          spaceDocument['bairro'],
          spaceDocument['cidade'],
          spaceDocument['selectedTypes'],
          spaceDocument['selectedServices'],
          spaceDocument['availableDays'],
        );
      }).toList();

      return Success(spaceModels);
    } catch (e) {
      log('Erro ao recuperar todos os espaços: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar todos os espaços'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceModel>>> getMySpaces() async {
    try {
      final spaceDocuments =
          await spacesCollection.where('user_id', isEqualTo: user.uid).get();
      final spaceModels = spaceDocuments.docs.map((spaceDocument) {
        //final spaceAddress = spaceDocument['space_address'];

        return SpaceModel(
          false,
          spaceDocument['space_id'],
          spaceDocument['user_id'],
          spaceDocument['email_do_espaço'],
          spaceDocument['nome_do_espaço'],
          spaceDocument['cep'],
          spaceDocument['logradouro'],
          spaceDocument['numero'],
          spaceDocument['bairro'],
          spaceDocument['cidade'],
          spaceDocument['selectedTypes'],
          spaceDocument['selectedServices'],
          spaceDocument['availableDays'],
        );
      }).toList();

      return Success(spaceModels);
    } catch (e) {
      log('Erro ao recuperar meus espaços: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar meus espaços'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceModel>>>
      getMyFavoriteSpaces() async {
    try {
      final userDocument =
          await usersCollection.where('uid', isEqualTo: user.uid).get();

      List<dynamic> userSpacesFavorite = [];

      if (userDocument.docs.isNotEmpty) {
        log('O documento do usuário foi encontrado');
        // O documento do usuário foi encontrado
        final userData = userDocument.docs[0].data() as Map<String, dynamic>;
        if (userData.containsKey('spaces_favorite')) {
          userSpacesFavorite = userData['spaces_favorite'] ?? [];
          log('Lista de espaços favoritos: $userSpacesFavorite');
        } else {
          log('O campo "spaces_favorite" não existe no documento do usuário.');
        }
      } else {
        log('Nenhum documento do usuário foi encontrado.');
      }

      // Lista a ser usada para armazenar os modelos construídos
      List<SpaceModel> result = [];

      // Pegando todos os documentos da coleção de espaços
      final spaceDocuments = await spacesCollection.get();

      // Percorrendo cada documento dessa coleção
      for (var spaceDocument in spaceDocuments.docs) {
        log('entrou no for');
        final isFavorited =
            userSpacesFavorite.contains(spaceDocument['space_id']);
        log('$isFavorited');

        if (isFavorited) {
          result.add(SpaceModel(
            isFavorited,
            spaceDocument['space_id'] ?? '',
            spaceDocument['user_id'] ?? '',
            spaceDocument['email_do_espaço'] ?? '',
            spaceDocument['nome_do_espaço'] ?? '',
            spaceDocument['cep'] ?? '',
            spaceDocument['logradouro'] ?? '',
            spaceDocument['numero'] ?? '',
            spaceDocument['bairro'] ?? '',
            spaceDocument['cidade'] ?? '',
            spaceDocument['selectedTypes'] ?? '',
            spaceDocument['selectedServices'] ?? '',
            spaceDocument['availableDays'] ?? '',
          ));
        }
      }

      return Success(result);
    } catch (e) {
      log('Erro ao recuperar meus espaços favoritos: $e');
      return Failure(RepositoryException(
          message: 'Erro ao carregar meus espaços favoritos'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> toggleFavoriteSpace(
      String spaceId, bool isFavorited) async {
    QuerySnapshot querySnapshot =
        await usersCollection.where("uid", isEqualTo: user.uid).get();

    if (querySnapshot.docs.length == 1) {
      final userDocument = querySnapshot.docs.first;
      String x;

      if (isFavorited) {
        userDocument.reference.update({
          'spaces_favorite': FieldValue.arrayUnion([spaceId]),
        });
        x = 'add';
      } else {
        userDocument.reference.update({
          'spaces_favorite': FieldValue.arrayRemove([spaceId]),
        });
        x = 'removed';
      }
      log('sucesso! - $x -  $spaceId');
      return Success(nil);
    } else {
      log('Documento do usuário não encontrado');
      return Failure(
          RepositoryException(message: 'Documento do usuário não encontrado'));
    }
  }
}

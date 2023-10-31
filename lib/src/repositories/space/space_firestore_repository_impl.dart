// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';
import 'package:git_flutter_festou/src/repositories/images/images_storage_repository.dart';
import 'package:git_flutter_festou/src/repositories/space/space_firestore_repository.dart';

class SpaceFirestoreRepositoryImpl implements SpaceFirestoreRepository {
  final ImagesStorageRepository imagesStorageRepository;
  SpaceFirestoreRepositoryImpl({
    required this.imagesStorageRepository,
  });
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
        List<File> imageFiles,
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

      // Consulte a coleção 'spaces' para verificar se um espaço com as mesmas informações já existe.
      final existingSpace = await spacesCollection
          .where('email_do_espaço', isEqualTo: spaceData.email)
          .where('nome_do_espaço', isEqualTo: spaceData.name)
          .where('cep', isEqualTo: spaceData.cep)
          .where('logradouro', isEqualTo: spaceData.logradouro)
          .where('numero', isEqualTo: spaceData.numero)
          .where('bairro', isEqualTo: spaceData.bairro)
          .where('cidade', isEqualTo: spaceData.cidade)
          .get();

      // Se não houver documentos correspondentes, insira o novo espaço.
      if (existingSpace.docs.isEmpty) {
        await spacesCollection.add(newSpace);
        imagesStorageRepository.uploadSpaceImages(
          imageFiles: spaceData.imageFiles,
          spaceId: spaceData.spaceId,
        );
        log('Informações de espaço adicionadas com sucesso!');
        return Success(nil);
      } else {
        log('Espaço já existe no Firestore');
        return Failure(RepositoryException(message: 'Esse espaço já existe'));
      }
    } catch (e) {
      log('Erro ao adicionar informações de espaço no firestore: $e');
      return Failure(RepositoryException(message: 'Erro ao cadastrar espaço'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getAllSpaces() async {
    try {
      //pega todos os documentos dos espaços
      final allSpaceDocuments = await spacesCollection.get();

//await pois retorna future
//pega os favoritos do usuario
      final userSpacesFavorite = await getUserFavoriteSpaces();

/*percorre todos os espaços levando em conta os favoritos
p decidir o isFavorited*/

//todo: mapSpaceDocumentToModel ajustado
      List<SpaceModel> spaceModels =
          allSpaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList();

      final spaceWithImagesList = <SpaceWithImages>[];

      for (var space in spaceModels) {
        final imageResult =
            await imagesStorageRepository.getSpaceImages(space.spaceId);

        switch (imageResult) {
          case Success(value: final imagesData):
            spaceWithImagesList.add(SpaceWithImages(space, imagesData));
          case Failure():
            log('Erro ao recuperar imagens: $imageResult');
        }
      }

      return Success(spaceWithImagesList);
    } catch (e) {
      log('Erro ao recuperar todos os espaços: $e');
      return Failure(RepositoryException(message: 'Erro ao carregar espaços'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getMySpaces() async {
    try {
      //espaços a serem buildado
      final mySpaceDocuments =
          await spacesCollection.where('user_id', isEqualTo: user.uid).get();

//favoritos do usuario
      final userSpacesFavorite = await getUserFavoriteSpaces();

//percorre tudo.
//todo: mapSpaceDocumentToModel ajustado
      List<SpaceModel> spaceModels = mySpaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList();
      final spaceWithImagesList = <SpaceWithImages>[];

      for (var space in spaceModels) {
        final imageResult =
            await imagesStorageRepository.getSpaceImages(space.spaceId);

        switch (imageResult) {
          case Success(value: final imagesData):
            spaceWithImagesList.add(SpaceWithImages(space, imagesData));
          case Failure():
            log('Erro ao recuperar imagens: $imageResult');
        }
      }

      return Success(spaceWithImagesList);
    } catch (e) {
      log('Erro ao recuperar meus espaços: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar meus espaços'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getMyFavoriteSpaces() async {
    try {
      //lista de espaços favoritados pelo usuario
      final userSpacesFavorite = await getUserFavoriteSpaces();

/*pegando os documentos dos espaços que seu id está na tal lista de favoritados pelo usuario
    Agora, em vez de buscar todos os espaços, filtramos diretamente os favoritos
    
    o retorno da lista de espaços favoritados serve para atribuir o 
    isFavorited na hora de exibir os espaços
    
    */
      if (userSpacesFavorite != null && userSpacesFavorite.isNotEmpty) {
        final favoriteSpaceDocuments = await spacesCollection
            .where('space_id', whereIn: userSpacesFavorite)
            .get();

//pra percorrer tudo, precisamos ter a lista de favoritados pelo usuario
//e a lista de documentos dos espaços que devem ser buildados
//todo: mapSpaceDocumentToModel ajustado
        List<SpaceModel> spaceModels =
            favoriteSpaceDocuments.docs.map((spaceDocument) {
          final isFavorited =
              userSpacesFavorite.contains(spaceDocument['space_id']) ?? false;
          return mapSpaceDocumentToModel(spaceDocument, isFavorited);
        }).toList();
        final spaceWithImagesList = <SpaceWithImages>[];

        for (var space in spaceModels) {
          final imageResult =
              await imagesStorageRepository.getSpaceImages(space.spaceId);

          switch (imageResult) {
            case Success(value: final imagesData):
              spaceWithImagesList.add(SpaceWithImages(space, imagesData));
            case Failure():
              log('Erro ao recuperar imagens: $imageResult');
          }
        }

        return Success(spaceWithImagesList);
      } //tratando caso emm que nao há espaços favoritados pelo usario
      else {
        return Success([]);
      }
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
      log('nenhum documento desse espaço foi encontrado, ou mais de 1 foram encontrados.');
      return Failure(RepositoryException(
          message: 'Espaço não encontrado no banco de dados'));
    }
  }

//build dos espaços
//todo: buildar levando em conta espaços e lista de favoritos
  SpaceModel mapSpaceDocumentToModel(
    QueryDocumentSnapshot spaceDocument,
    bool isFavorited,
  ) {
    List<String> selectedTypes =
        List<String>.from(spaceDocument['selectedTypes'] ?? []);
    List<String> selectedServices =
        List<String>.from(spaceDocument['selectedServices'] ?? []);
    List<String> availableDays =
        List<String>.from(spaceDocument['availableDays'] ?? []);

    return SpaceModel(
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
      selectedTypes,
      selectedServices,
      availableDays,
    );
  }

//retorna o documento do usuario atual
  Future<DocumentSnapshot> getUserDocument() async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: user.uid).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0]; // Retorna o primeiro documento encontrado.
    }

    // Trate o caso em que nenhum usuário foi encontrado.
    throw Exception("Usuário não encontrado");
  }

//retorna a lista de ids dos espaços favoritados pelo usuario
  Future<List<String>?> getUserFavoriteSpaces() async {
    final userDocument = await getUserDocument();

    final userData = userDocument.data() as Map<String, dynamic>;

    if (userData.containsKey('spaces_favorite')) {
      return List<String>.from(userData['spaces_favorite'] ?? []);
    }

    return null;
  }

  @override
  Future<Either<RepositoryException, List<SpaceWithImages>>> getSpacesByType(
      List<String> types) async {
    try {
      // Consulta espaços onde o campo "selectedTypes" contenha pelo menos um dos tipos da lista.
      final spaceDocuments = await spacesCollection
          .where('selectedTypes', arrayContainsAny: types)
          .get();

      final userSpacesFavorite = await getUserFavoriteSpaces();

      // Mapeia os documentos de espaço para objetos SpaceModel.
      List<SpaceModel> spaceModels = spaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;

        return mapSpaceDocumentToModel(
          spaceDocument,
          isFavorited,
        );
      }).toList();

      final spaceWithImagesList = <SpaceWithImages>[];

      for (var space in spaceModels) {
        final imageResult =
            await imagesStorageRepository.getSpaceImages(space.spaceId);

        switch (imageResult) {
          case Success(value: final imagesData):
            spaceWithImagesList.add(SpaceWithImages(space, imagesData));
            break; // Break the switch statement after a successful image retrieval.
          case Failure():
            log('Erro ao recuperar imagens: $imageResult');
        }
      }

      return Success(spaceWithImagesList);
    } catch (e) {
      log('Erro ao recuperar espaços por tipo: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar espaços por tipo'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getSpacesWithSugestion(SpaceWithImages spaceWithImages) {
    // TODO: implement getSpacesWithSugestion
    throw UnimplementedError();
  }

  @override
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getSurroundingSpaces() {
    // TODO: implement getSurroundingSpaces
    throw UnimplementedError();
  }
}

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
import 'package:git_flutter_festou/src/repositories/feedback/feedback_firestore_repository.dart';
import 'package:git_flutter_festou/src/repositories/images/images_storage_repository.dart';
import 'package:git_flutter_festou/src/repositories/space/space_firestore_repository.dart';

class SpaceFirestoreRepositoryImpl implements SpaceFirestoreRepository {
  final ImagesStorageRepository imagesStorageRepository;
  final FeedbackFirestoreRepository feedbackFirestoreRepository;
  SpaceFirestoreRepositoryImpl({
    required this.imagesStorageRepository,
    required this.feedbackFirestoreRepository,
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
        String titulo,
        String bairro,
        String cep,
        String cidade,
        String logradouro,
        String numero,
        List<String> selectedTypes,
        List<String> selectedServices,
        List<File> imageFiles,
        String descricao,
        String city
      }) spaceData) async {
    try {
      final locadorName = await getLocadorName(spaceData.userId);
      // Crie um novo espaço com os dados fornecidos
      Map<String, dynamic> newSpace = {
        'space_id': spaceData.spaceId,
        'user_id': spaceData.userId,
        'titulo': spaceData.titulo,
        'cep': spaceData.cep,
        'logradouro': spaceData.logradouro,
        'numero': spaceData.numero,
        'bairro': spaceData.bairro,
        'cidade': spaceData.cidade,
        'selectedTypes': spaceData.selectedTypes,
        'selectedServices': spaceData.selectedServices,
        'average_rating': '0',
        'num_comments': '0',
        'locador_name': locadorName,
        'descricao': spaceData.descricao,
        'city': spaceData.city,
      };

      // Consulte a coleção 'spaces' para verificar se um espaço com as mesmas informações já existe.
      final existingSpace = await spacesCollection
          .where('titulo', isEqualTo: spaceData.titulo)
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
          await Future.wait(allSpaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList());

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
      List<SpaceModel> spaceModels =
          await Future.wait(mySpaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList());
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
        List<SpaceModel> spaceModels = await Future.wait(
          favoriteSpaceDocuments.docs.map((spaceDocument) async {
            final isFavorited =
                userSpacesFavorite.contains(spaceDocument['space_id']) ?? false;
            return await mapSpaceDocumentToModel(spaceDocument, isFavorited);
          }),
        );

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
  Future<SpaceModel> mapSpaceDocumentToModel(
    QueryDocumentSnapshot spaceDocument,
    bool isFavorited,
  ) async {
    //pegando os dados necssarios antes de crior o card
    List<String> selectedTypes =
        List<String>.from(spaceDocument['selectedTypes'] ?? []);
    List<String> selectedServices =
        List<String>.from(spaceDocument['selectedServices'] ?? []);

    String spaceId = spaceDocument.get('space_id');
    //String userId = spaceDocument.get('user_id');
    final averageRating = await getAverageRating(spaceId);
    final numComments = await getNumComments(spaceId);
    //final locadorName = await getLocadorName(userId);
    return SpaceModel(
      isFavorited,
      spaceDocument['space_id'] ?? '',
      spaceDocument['user_id'] ?? '',
      spaceDocument['titulo'] ?? '',
      spaceDocument['cep'] ?? '',
      spaceDocument['logradouro'] ?? '',
      spaceDocument['numero'] ?? '',
      spaceDocument['bairro'] ?? '',
      spaceDocument['cidade'] ?? '',
      selectedTypes,
      selectedServices,
      averageRating,
      numComments,
      spaceDocument['locador_name'] ?? '',
      spaceDocument['descricao'] ?? '',
      spaceDocument['city'] ?? '',
    );
  }

  Future<String> getLocadorName(String userId) async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: userId).get();

    if (userDocument.docs.isNotEmpty) {
      String locadorName = userDocument.docs.first['nome'];
      return locadorName;
    }

    // Trate o caso em que nenhum espaço foi encontrado.
    throw Exception("Espaço não encontrado");
  }

  Future<String> getAverageRating(String spaceId) async {
    final spaceDocument =
        await spacesCollection.where('space_id', isEqualTo: spaceId).get();

    if (spaceDocument.docs.isNotEmpty) {
      String averageRatingValue = spaceDocument.docs.first['average_rating'];
      return averageRatingValue;
    }

    // Trate o caso em que nenhum espaço foi encontrado.
    throw Exception("Espaço não encontrado");
  }

  Future<String> getNumComments(String spaceId) async {
    final spaceDocument =
        await spacesCollection.where('space_id', isEqualTo: spaceId).get();

    if (spaceDocument.docs.isNotEmpty) {
      String numComments = spaceDocument.docs.first['num_comments'];
      return numComments;
    }

    // Trate o caso em que nenhum espaço foi encontrado.
    throw Exception("Espaço não encontrado");
  }

//retorna o documento do usuario atual
  Future<DocumentSnapshot> getUserDocument() async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: user.uid).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0]; // Retorna o primeiro documento encontrado.
    }

    // Trate o caso em que nenhum usuário foi encontrado.
    //se esse erro ocorrer la numm metodo que chama getUsrDocument, o (e) do catch vai ter essa msg
    throw Exception("Usuário n encontrado");
    //! erro as vezes, se deletar a conta com google e criar de novo rapidao, o
    //!documento no firestore e auth estão certos, com o mesmo id, mas o objeto user do auth que o programa
    //!carrega primeiramente é o anterior já excluido, com o uid antigo
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
      List<SpaceModel> spaceModels =
          await Future.wait(spaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;

        return mapSpaceDocumentToModel(
          spaceDocument,
          isFavorited,
        );
      }).toList());

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
  Future<Either<RepositoryException, List<SpaceWithImages>>> getSugestions(
      SpaceWithImages spaceWithImages) async {
    try {
      // Obtém os tipos do espaço fornecido.
      final selectedTypes = spaceWithImages.space.selectedTypes;

      // Consulta espaços que possuam pelo menos um dos tipos encontrados.
      final spacesResult = await getSpacesWithSameTypes(selectedTypes);

      switch (spacesResult) {
        case Success(value: final spacesData):
          final filteredSpaces = spacesData
              .where((space) =>
                  space.space.spaceId != spaceWithImages.space.spaceId)
              .toList();
          return Success(filteredSpaces);
        case Failure(exception: RepositoryException(:final message)):
          return Failure(RepositoryException(message: message));
      }
    } catch (e) {
      return Failure(
          RepositoryException(message: 'Erro ao buscar sugestões de espaços'));
    }
  }

  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getSpacesWithSameTypes(List<dynamic> types) async {
    try {
      final userSpacesFavorite = await getUserFavoriteSpaces();

      // Consulta espaços onde o campo "selectedTypes" contenha pelo menos um dos tipos da lista.
      final spaceDocuments = await spacesCollection
          .where('selectedTypes', arrayContainsAny: types)
          .get();

      // Mapeia os documentos de espaço para objetos SpaceModel.
      List<SpaceModel> spaceModels =
          await Future.wait(spaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList());

      final spaceWithImagesList = <SpaceWithImages>[];

      for (var space in spaceModels) {
        final imageResult =
            await imagesStorageRepository.getSpaceImages(space.spaceId);

        switch (imageResult) {
          case Success(value: final imagesData):
            spaceWithImagesList.add(SpaceWithImages(space, imagesData));
            break;
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
      getSurroundingSpaces() {
    // TODO: implement getSurroundingSpaces
    throw UnimplementedError();
  }

  @override
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getSpacesBySelectedTypes({
    List<String>? selectedTypes,
  }) async {
    try {
      final userSpacesFavorite = await getUserFavoriteSpaces();
      Query query = spacesCollection;

      if (selectedTypes != null && selectedTypes.isNotEmpty) {
        query = query.where('selectedTypes', arrayContainsAny: selectedTypes);
      } else {
        // Se a lista  estiver vazia, retorne uma lista vazia diretamente.
        return Success([]);
      }

      final spaceDocuments = await query.get();

      // Mapeia os documentos de espaço para objetos SpaceModel.
      final spaceModels =
          await Future.wait(spaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList());

      final spaceWithImagesList = <SpaceWithImages>[];

      for (var space in spaceModels) {
        final imageResult =
            await imagesStorageRepository.getSpaceImages(space.spaceId);

        switch (imageResult) {
          case Success(value: final imagesData):
            spaceWithImagesList.add(SpaceWithImages(space, imagesData));
            break;
          case Failure():
            log('Erro ao recuperar imagens: $imageResult');
        }
      }

      return Success(spaceWithImagesList);
    } catch (e) {
      log('Erro ao recuperar espaços filtrados: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar espaços filtrados'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getSpacesByAvailableDays({
    List<String>? availableDays,
  }) async {
    try {
      final userSpacesFavorite = await getUserFavoriteSpaces();
      Query query = spacesCollection;

      if (availableDays != null && availableDays.isNotEmpty) {
        query = query.where('availableDays', arrayContainsAny: availableDays);
      } else {
        // Se a lista  estiver vazia, retorne uma lista vazia diretamente.
        return Success([]);
      }

      final spaceDocuments = await query.get();

      // Mapeia os documentos de espaço para objetos SpaceModel.
      final spaceModels =
          await Future.wait(spaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList());

      final spaceWithImagesList = <SpaceWithImages>[];

      for (var space in spaceModels) {
        final imageResult =
            await imagesStorageRepository.getSpaceImages(space.spaceId);

        switch (imageResult) {
          case Success(value: final imagesData):
            spaceWithImagesList.add(SpaceWithImages(space, imagesData));
            break;
          case Failure():
            log('Erro ao recuperar imagens: $imageResult');
        }
      }

      return Success(spaceWithImagesList);
    } catch (e) {
      log('Erro ao recuperar espaços filtrados: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar espaços filtrados'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceWithImages>>>
      getSpacesBySelectedServices({
    List<String>? selectedServices,
  }) async {
    try {
      final userSpacesFavorite = await getUserFavoriteSpaces();
      Query query = spacesCollection;

      if (selectedServices != null && selectedServices.isNotEmpty) {
        // Filtra espaços que contenham pelo menos um dos serviços selecionados
        query =
            query.where('selectedServices', arrayContainsAny: selectedServices);
      } else {
        // Se a lista selectedServices estiver vazia, retorne uma lista vazia diretamente.
        return Success([]);
      }

      final spaceDocuments = await query.get();

      // Mapeia os documentos de espaço para objetos SpaceModel.
      final spaceModels =
          await Future.wait(spaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList());

      final spaceWithImagesList = <SpaceWithImages>[];

      for (var space in spaceModels) {
        final imageResult =
            await imagesStorageRepository.getSpaceImages(space.spaceId);

        switch (imageResult) {
          case Success(value: final imagesData):
            spaceWithImagesList.add(SpaceWithImages(space, imagesData));
            break;
          case Failure():
            log('Erro ao recuperar imagens: $imageResult');
        }
      }
      log('$spaceWithImagesList');
      return Success(spaceWithImagesList);
    } catch (e) {
      log('Erro ao recuperar espaços filtrados: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar espaços filtrados'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceWithImages>>> filterSpaces(
      List<SpaceWithImages> spaces1,
      List<SpaceWithImages> spaces2,
      List<SpaceWithImages> spaces3) async {
    try {
      if (spaces1.isNotEmpty && spaces2.isEmpty && spaces3.isEmpty) {
        return Success(spaces1);
      } else if (spaces1.isEmpty && spaces2.isNotEmpty && spaces3.isEmpty) {
        return Success(spaces2);
      } else if (spaces1.isEmpty && spaces2.isEmpty && spaces3.isNotEmpty) {
        return Success(spaces3);
      } else if (spaces1.isNotEmpty && spaces2.isNotEmpty && spaces3.isEmpty) {
        final intersection = spaces1
            .where((space1) => spaces2
                .any((space2) => space1.space.spaceId == space2.space.spaceId))
            .toList();
        return Success(intersection);
      } else if (spaces1.isNotEmpty && spaces2.isEmpty && spaces3.isNotEmpty) {
        final intersection = spaces1
            .where((space1) => spaces3
                .any((space3) => space1.space.spaceId == space3.space.spaceId))
            .toList();
        return Success(intersection);
      } else if (spaces1.isEmpty && spaces2.isNotEmpty && spaces3.isNotEmpty) {
        final intersection = spaces2
            .where((space2) => spaces3
                .any((space3) => space2.space.spaceId == space3.space.spaceId))
            .toList();
        return Success(intersection);
      } else if (spaces1.isNotEmpty &&
          spaces2.isNotEmpty &&
          spaces3.isNotEmpty) {
        final intersection1 = spaces1
            .where((space1) => spaces2
                .any((space2) => space1.space.spaceId == space2.space.spaceId))
            .toList();
        final finalIntersection = intersection1
            .where((space1) => spaces3
                .any((space3) => space1.space.spaceId == space3.space.spaceId))
            .toList();
        return Success(finalIntersection);
      } else {
        return Success([]); // Todas as listas estão vazias
      }
    } catch (e) {
      log('Erro ao recuperar espaços filtrados no filterSpaces: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar espaços filtrados'));
    }
  }
}

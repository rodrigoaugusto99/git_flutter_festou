// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:festou/src/core/exceptions/repository_exception.dart';
import 'package:festou/src/core/fp/either.dart';
import 'package:festou/src/core/fp/nil.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:festou/src/models/user_model.dart';
import 'package:festou/src/repositories/feedback/feedback_firestore_repository.dart';
import 'package:festou/src/repositories/images/images_storage_repository.dart';
import 'package:festou/src/repositories/space/space_firestore_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
        String estado,
        String numero,
        List<String> selectedTypes,
        List<String> selectedServices,
        List<File> imageFiles,
        List<File> videoFiles,
        String descricao,
        String preco,
        double latitude,
        double longitude,
        Days days,
        //String deletedAt,
        //String cnpjEmpresaLocadora,
        // String locadorCpf,
        // String nomeEmpresaLocadora,
        // String locadorAssinatura,
      }) spaceData) async {
    try {
      // Crie um novo espaço com os dados fornecidos

      // Consulte a coleção 'spaces' para verificar se um espaço com as mesmas informações já existe.
      final existingSpace = await spacesCollection
          .where('deletedAt', isNull: true)
          .where('titulo', isEqualTo: spaceData.titulo)
          .where('cep', isEqualTo: spaceData.cep)
          .where('logradouro', isEqualTo: spaceData.logradouro)
          .where('numero', isEqualTo: spaceData.numero)
          .where('bairro', isEqualTo: spaceData.bairro)
          .where('cidade', isEqualTo: spaceData.cidade)
          .get();

      // Se não houver documentos correspondentes, insira o novo espaço.
      if (existingSpace.docs.isEmpty) {
        await imagesStorageRepository.uploadSpaceImages(
          imageFiles: spaceData.imageFiles,
          spaceId: spaceData.spaceId,
        );

        final spaceImagesUrls =
            await imagesStorageRepository.getSpaceImages(spaceData.spaceId);

        await imagesStorageRepository.uploadSpaceVideos(
          videoFiles: spaceData.videoFiles,
          spaceId: spaceData.spaceId,
        );

        final spaceVideosUrls =
            await imagesStorageRepository.getSpaceVideos(spaceData.spaceId);

        switch (spaceImagesUrls) {
          case Success(value: final imagesData):
            final locadorName = await getLocadorName(spaceData.userId);
            final locadorAvatar = await getLocadorAvatar(spaceData.userId);
            final locadorModel = await getLocadorModel(spaceData.userId);

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
              'num_comments': '0',
              'locador_name': locadorName,
              'descricao': spaceData.descricao,
              'latitude': spaceData.latitude,
              'longitude': spaceData.longitude,
              'locadorAvatarUrl': locadorAvatar,
              'weekdays': spaceData.days.toMap(),
              'preco': spaceData.preco,
              'cnpj_empresa_locadora': locadorModel!.cnpj,
              'estado': spaceData.estado,
              'locador_assinatura': locadorModel.assinatura,
              'locador_cpf': locadorModel.cpf,
              'nome_empresa_locadora': locadorModel.fantasyName,
              'num_likes': 0,
              'images_url': imagesData,
              'videos': spaceVideosUrls,
              'createdAt': FieldValue.serverTimestamp(),
              'deletedAt': null,
            };
            await spacesCollection.add(newSpace);

          case Failure():
            return Failure(RepositoryException(
                message: 'Nao foi possivel recuperar as imagens'));
        }

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
  Future<Either<RepositoryException, List<SpaceModel>>> getAllSpaces() async {
    try {
      //pega todos os documentos dos espaços
      final allSpaceDocuments =
          await spacesCollection.where('deletedAt', isNull: true).get();

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

      return Success(spaceModels);
    } catch (e) {
      log('Erro ao recuperar todos os espaços: $e');
      return Failure(RepositoryException(message: 'Erro ao carregar espaços'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceModel>>> getSurroundingSpaces(
    LatLngBounds visibleRegion,
  ) async {
    try {
      // Acesse sua coleção "spaces" no Firestore
      QuerySnapshot surroundingSpaces = await spacesCollection
          .where('deletedAt', isNull: true)
          .where(
            'latitude', // Substitua 'latitude' pelo nome do campo correspondente no Firestore
            isGreaterThanOrEqualTo: visibleRegion.southwest.latitude,
            isLessThanOrEqualTo: visibleRegion.northeast.latitude,
          )
          .get();

      surroundingSpaces = await spacesCollection
          .where('deletedAt', isNull: true)
          .where(
            'longitude', // Substitua 'longitude' pelo nome do campo correspondente no Firestore
            isGreaterThanOrEqualTo: visibleRegion.southwest.longitude,
            isLessThanOrEqualTo: visibleRegion.northeast.longitude,
          )
          .get();

      // Obtém os favoritos do usuário
      final userSpacesFavorite = await getUserFavoriteSpaces();

      // Mapeia os documentos para modelos de espaço
      List<SpaceModel> spaceModels =
          await Future.wait(surroundingSpaces.docs.map((spaceDocument) async {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return await mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList());

      return Success(spaceModels);
    } catch (e) {
      log('Erro ao obter espaços na região visível: $e');
      return Failure(RepositoryException(
          message: 'Erro ao carregar espaços na região visível'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceModel>>> getMySpaces() async {
    try {
      //espaços a serem buildado
      final mySpaceDocuments = await spacesCollection
          .where('user_id', isEqualTo: user.uid)
          .where('deletedAt', isNull: true)
          .get();

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
            .where('deletedAt', isNull: true)
            .get();

//pra percorrer tudo, precisamos ter a lista de favoritados pelo usuario
//e a lista de documentos dos espaços que devem ser buildados
//todo: mapSpaceDocumentToModel ajustado
        List<SpaceModel> spaceModels = await Future.wait(
          favoriteSpaceDocuments.docs.map((spaceDocument) async {
            final isFavorited =
                userSpacesFavorite.contains(spaceDocument['space_id']);
            return await mapSpaceDocumentToModel(spaceDocument, isFavorited);
          }),
        );

        return Success(spaceModels);
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
    try {
      // Busca o documento do usuário
      QuerySnapshot querySnapshot =
          await usersCollection.where("uid", isEqualTo: user.uid).get();

      if (querySnapshot.docs.length == 1) {
        final userDocument = querySnapshot.docs.first;

        // Atualiza o documento do usuário
        if (isFavorited) {
          await userDocument.reference.update({
            'spaces_favorite': FieldValue.arrayUnion([spaceId]),
          });
          log('sucesso! - add -  $spaceId');
        } else {
          await userDocument.reference.update({
            'spaces_favorite': FieldValue.arrayRemove([spaceId]),
          });
          log('sucesso! - removed -  $spaceId');
        }

        // Busca o documento do espaço pelo space_id
        QuerySnapshot spaceSnapshot = await spacesCollection
            .where('space_id', isEqualTo: spaceId)
            .where('deletedAt', isNull: true)
            .limit(1)
            .get();

        if (spaceSnapshot.docs.isNotEmpty) {
          final spaceDocument = spaceSnapshot.docs.first;

          // Atualiza o campo num_likes no documento do espaço
          if (isFavorited) {
            await spaceDocument.reference.update({
              'num_likes': FieldValue.increment(1),
            });
          } else {
            await spaceDocument.reference.update({
              'num_likes': FieldValue.increment(-1),
            });
          }
        } else {
          log('Nenhum documento do espaço foi encontrado.');
          return Failure(RepositoryException(
              message: 'Espaço não encontrado no banco de dados'));
        }

        return Success(nil);
      } else {
        log('Nenhum documento de usuário foi encontrado, ou mais de 1 foi encontrado.');
        return Failure(RepositoryException(
            message: 'Usuário não encontrado no banco de dados'));
      }
    } catch (e) {
      log('Erro ao atualizar o espaço favorito: $e');
      return Failure(
          RepositoryException(message: 'Erro ao atualizar o espaço favorito'));
    }
  }

//build dos espaços
//todo: buildar levando em conta espaços e lista de favoritos

  Future<String> getLocadorName(String userId) async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: userId).get();

    if (userDocument.docs.isNotEmpty) {
      String locadorName = userDocument.docs.first['name'];
      return locadorName;
    }

    // Trate o caso em que nenhum espaço foi encontrado.
    throw Exception("Espaço não encontrado");
  }

  Future<String> getLocadorAvatar(String userId) async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: userId).get();

    if (userDocument.docs.isNotEmpty) {
      String locadorAvatar = userDocument.docs.first['avatar_url'];
      return locadorAvatar;
    }

    // Trate o caso em que nenhum espaço foi encontrado.
    throw Exception("Espaço não encontrado");
  }

  Future<UserModel?> getLocadorModel(String userId) async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: userId).get();

    if (userDocument.docs.isNotEmpty) {
      final doc = userDocument.docs.first;
      final data = doc.data();

      if (data is Map<String, dynamic>) {
        UserModel userModel = UserModel.fromMap(data);

        return userModel;
      } else {
        return null;
      }
    }
    return null;
  }

  Future<String> getNumComments(String spaceId) async {
    final spaceDocument =
        await spacesCollection.where('space_id', isEqualTo: spaceId).get();

    if (spaceDocument.docs.isNotEmpty) {
      String numComments = spaceDocument.docs.first['num_comments'];
      return numComments;
    }

    throw Exception("Espaço não encontrado");
  }

  Future<DocumentSnapshot> getUserDocument() async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: user.uid).limit(1).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs.first;
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
  Future<Either<RepositoryException, List<SpaceModel>>> getSpacesByType(
      List<String> types) async {
    try {
      // Consulta espaços onde o campo "selectedTypes" contenha pelo menos um dos tipos da lista.
      final spaceDocuments = await spacesCollection
          .where('selectedTypes', arrayContainsAny: types)
          .where('deletedAt', isNull: true)
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

      return Success(spaceModels);
    } catch (e) {
      log('Erro ao recuperar espaços por tipo: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar espaços por tipo'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceModel>>> getSugestions(
      SpaceModel spaceModel) async {
    try {
      // Obtém os tipos do espaço fornecido.
      final selectedTypes = spaceModel.selectedTypes;

      // Consulta espaços que possuam pelo menos um dos tipos encontrados.
      final spacesResult = await getSpacesWithSameTypes(selectedTypes);

      switch (spacesResult) {
        case Success(value: final spacesData):
          final filteredSpaces = spacesData
              .where((space) => space.spaceId != spaceModel.spaceId)
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

  Future<Either<RepositoryException, List<SpaceModel>>> getSpacesWithSameTypes(
      List<dynamic> types) async {
    try {
      final userSpacesFavorite = await getUserFavoriteSpaces();

      // Consulta espaços onde o campo "selectedTypes" contenha pelo menos um dos tipos da lista.
      final spaceDocuments = await spacesCollection
          .where('selectedTypes', arrayContainsAny: types)
          .where('deletedAt', isNull: true)
          .get();

      // Mapeia os documentos de espaço para objetos SpaceModel.
      List<SpaceModel> spaceModels =
          await Future.wait(spaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList());

      return Success(spaceModels);
    } catch (e) {
      log('Erro ao recuperar espaços por tipo: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar espaços por tipo'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceModel>>>
      getSpacesBySelectedTypes({
    List<String>? selectedTypes,
  }) async {
    try {
      final userSpacesFavorite = await getUserFavoriteSpaces();
      Query query = spacesCollection;

      if (selectedTypes != null && selectedTypes.isNotEmpty) {
        query = query
            .where('selectedTypes', arrayContainsAny: selectedTypes)
            .where('deletedAt', isNull: true);
      } else {
        // Se a lista  estiver vazia, retorne uma lista vazia diretamente.
        return Success([]);
      }

      final spaceDocuments = await query.where('deletedAt', isNull: true).get();

      // Mapeia os documentos de espaço para objetos SpaceModel.
      final spaceModels =
          await Future.wait(spaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList());

      return Success(spaceModels);
    } catch (e) {
      log('Erro ao recuperar espaços filtrados: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar espaços filtrados'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceModel>>>
      getSpacesByAvailableDays({
    List<String>? availableDays,
  }) async {
    try {
      final userSpacesFavorite = await getUserFavoriteSpaces();
      Query query = spacesCollection;

      if (availableDays != null && availableDays.isNotEmpty) {
        query = query
            .where('availableDays', arrayContainsAny: availableDays)
            .where('deletedAt', isNull: true);
      } else {
        // Se a lista  estiver vazia, retorne uma lista vazia diretamente.
        return Success([]);
      }

      final spaceDocuments = await query.where('deletedAt', isNull: true).get();

      // Mapeia os documentos de espaço para objetos SpaceModel.
      final spaceModels =
          await Future.wait(spaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList());

      return Success(spaceModels);
    } catch (e) {
      log('Erro ao recuperar espaços filtrados: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar espaços filtrados'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceModel>>>
      getSpacesBySelectedServices({
    List<String>? selectedServices,
  }) async {
    try {
      final userSpacesFavorite = await getUserFavoriteSpaces();
      Query query = spacesCollection;

      if (selectedServices != null && selectedServices.isNotEmpty) {
        // Filtra espaços que contenham pelo menos um dos serviços selecionados
        query = query
            .where('selectedServices', arrayContainsAny: selectedServices)
            .where('deletedAt', isNull: true);
      } else {
        // Se a lista selectedServices estiver vazia, retorne uma lista vazia diretamente.
        return Success([]);
      }

      final spaceDocuments = await query.where('deletedAt', isNull: true).get();

      // Mapeia os documentos de espaço para objetos SpaceModel.
      final spaceModels =
          await Future.wait(spaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList());

      return Success(spaceModels);
    } catch (e) {
      log('Erro ao recuperar espaços filtrados: $e');
      return Failure(
          RepositoryException(message: 'Erro ao carregar espaços filtrados'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceModel>>> filterSpaces(
      List<SpaceModel> spaces1,
      List<SpaceModel> spaces2,
      List<SpaceModel> spaces3) async {
    try {
      if (spaces1.isNotEmpty && spaces2.isEmpty && spaces3.isEmpty) {
        return Success(spaces1);
      } else if (spaces1.isEmpty && spaces2.isNotEmpty && spaces3.isEmpty) {
        return Success(spaces2);
      } else if (spaces1.isEmpty && spaces2.isEmpty && spaces3.isNotEmpty) {
        return Success(spaces3);
      } else if (spaces1.isNotEmpty && spaces2.isNotEmpty && spaces3.isEmpty) {
        final intersection = spaces1
            .where((space1) =>
                spaces2.any((space2) => space1.spaceId == space2.spaceId))
            .toList();
        return Success(intersection);
      } else if (spaces1.isNotEmpty && spaces2.isEmpty && spaces3.isNotEmpty) {
        final intersection = spaces1
            .where((space1) =>
                spaces3.any((space3) => space1.spaceId == space3.spaceId))
            .toList();
        return Success(intersection);
      } else if (spaces1.isEmpty && spaces2.isNotEmpty && spaces3.isNotEmpty) {
        final intersection = spaces2
            .where((space2) =>
                spaces3.any((space3) => space2.spaceId == space3.spaceId))
            .toList();
        return Success(intersection);
      } else if (spaces1.isNotEmpty &&
          spaces2.isNotEmpty &&
          spaces3.isNotEmpty) {
        final intersection1 = spaces1
            .where((space1) =>
                spaces2.any((space2) => space1.spaceId == space2.spaceId))
            .toList();
        final finalIntersection = intersection1
            .where((space1) =>
                spaces3.any((space3) => space1.spaceId == space3.spaceId))
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

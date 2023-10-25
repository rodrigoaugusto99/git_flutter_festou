import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
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
        log('Informações de espaço adicionadas com sucesso!');
        return Success(Nil());
      } else {
        log('Espaço já existe no Firestore');
        return Failure(
            RepositoryException(message: 'Espaço já existe no Firestore'));
      }
    } catch (e) {
      log('Erro ao adicionar informações de espaço: $e');
      return Failure(RepositoryException(message: 'Erro ao cadastrar espaço'));
    }
  }

  @override
  Future<Either<RepositoryException, List<SpaceModel>>> getAllSpaces() async {
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
      //espaços a serem buildados
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
      final favoriteSpaceDocuments = await spacesCollection
          .where('space_id', whereIn: userSpacesFavorite)
          .get();

//pra percorrer tudo, precisamos ter a lista de favoritados pelo usuario
//e a lista de documentos dos espaços que devem ser buildados
//todo: mapSpaceDocumentToModel ajustado
      List<SpaceModel> spaceModels =
          favoriteSpaceDocuments.docs.map((spaceDocument) {
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDocument, isFavorited);
      }).toList();

      return Success(spaceModels);
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

//build dos espaços
//todo: buildar levando em conta espaços e lista de favoritos
  SpaceModel mapSpaceDocumentToModel(
      QueryDocumentSnapshot spaceDocument, bool isFavorited) {
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
      spaceDocument['selectedTypes'] ?? '',
      spaceDocument['selectedServices'] ?? '',
      spaceDocument['availableDays'] ?? '',
    );
  }

//retorna o documento do usuario atual
  Future<DocumentSnapshot> getUserId() async {
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
    final userDocument = await getUserId();

    final userData = userDocument.data() as Map<String, dynamic>;

    if (userData.containsKey('spaces_favorite')) {
      return List<String>.from(userData['spaces_favorite'] ?? []);
    }

    return null;
  }
}

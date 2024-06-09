import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/models/cupom_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:git_flutter_festou/src/repositories/space/space_firestore_repository_impl.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  //todo: colocar o parametro "id" aqui.
  //caso String id nao for null, entao esse ID
  //que vais er usado para a pesquisa, e nao o id do current.User
  //(sera usado p pegar user do feedback ou reserva etc.
  //)
  Future<UserModel?> getCurrentUserModel() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: firebaseUser.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        final data = userDoc.data() as Map<String, dynamic>;
        return UserModel(
          email: data['email'] ?? '',
          name: data['name'] ?? '',
          cpfOuCnpj: data['cpf'] ?? '',
          cep: data['user_address']?['cep'] ?? '',
          logradouro: data['user_address']?['logradouro'] ?? '',
          telefone: data['telefone'] ?? '',
          bairro: data['user_address']?['bairro'] ?? '',
          cidade: data['user_address']?['cidade'] ?? '',
          id: firebaseUser.uid,
          avatarUrl: data['avatar_url'] ?? '',
        );
      }
    }
    return null;
  }

//pega os dados do cupom
  Future<CupomModel?> getCupom(String codigo) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('cupons')
        .where('codigo', isEqualTo: codigo)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      final data = userDoc.data() as Map<String, dynamic>;
      return CupomModel(
        codigo: codigo,
        validade: data['validade'] ?? '',
        valorDesconto: data['valor_desconto'] ?? 0,
      );
    }

    return null;
  }

  Future<void> updateLastSeen(String spaceId) async {
    final user = await getCurrentUserModel();
    if (user == null) return;

    try {
      // Fetch the user document using a query
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.id)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("User does not exist!");
      }

      // Since we used limit(1), there should only be one document in the querySnapshot
      DocumentSnapshot snapshot = querySnapshot.docs.first;

      List<dynamic> lastSeen = snapshot.get('last_seen') ?? [];

      // Remove spaceId if it already exists
      lastSeen.remove(spaceId);

      // Add the new spaceId to the front
      lastSeen.insert(0, spaceId);

      // Ensure the array has at most 10 items
      if (lastSeen.length > 10) {
        lastSeen = lastSeen.sublist(0, 10);
      }

      // Update the user document
      await snapshot.reference.update({'last_seen': lastSeen});
    } catch (error) {
      log("Failed to update last seen: $error");
    }
  }

  Future<List<SpaceModel>?> getLastSeenSpaces() async {
    final user = await getCurrentUserModel();
    if (user != null) {
      // Fetch the user document using a query
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.id)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        throw Exception("User does not exist!");
      }

      DocumentSnapshot userDoc = userSnapshot.docs.first;
      List<dynamic> lastSeenIds = userDoc.get('last_seen') ?? [];

      // Get user's favorite spaces
      final userSpacesFavorite = await getUserFavoriteSpaces(user.id);

      List<Future<SpaceModel>> futures = lastSeenIds.map((id) async {
        QuerySnapshot spaceQuerySnapshot = await FirebaseFirestore.instance
            .collection('spaces')
            .where('space_id', isEqualTo: id)
            .limit(1)
            .get();

        if (spaceQuerySnapshot.docs.isEmpty) {
          throw Exception("Space does not exist!");
        }

        QueryDocumentSnapshot spaceDoc = spaceQuerySnapshot.docs.first;
        bool isFavorited =
            userSpacesFavorite?.contains(spaceDoc['space_id']) ?? false;
        return mapSpaceDocumentToModel(spaceDoc, isFavorited);
      }).toList();

      return await Future.wait(futures);
    }

    return null;
  }

  Future<SpaceModel> mapSpaceDocumentToModel(
    QueryDocumentSnapshot spaceDocument,
    bool isFavorited,
  ) async {
    //pegando os dados necssarios antes de crior o card
    List<String> selectedTypes =
        List<String>.from(spaceDocument['selectedTypes'] ?? []);
    List<String> selectedServices =
        List<String>.from(spaceDocument['selectedServices'] ?? []);
    List<String> imagesUrl =
        List<String>.from(spaceDocument['images_url'] ?? []);
    List<String> days = List<String>.from(spaceDocument['days'] ?? []);

    String spaceId = spaceDocument.get('space_id');
    //String userId = spaceDocument.get('user_id');
    final averageRating = await getAverageRating(spaceId);
    final numComments = await getNumComments(spaceId);
    //final locadorName = await getLocadorName(userId);

//?função para capturar a lista de imagens desse espaço

    return SpaceModel(
      isFavorited: isFavorited,
      spaceId: spaceDocument['space_id'] ?? '',
      userId: spaceDocument['user_id'] ?? '',
      titulo: spaceDocument['titulo'] ?? '',
      cep: spaceDocument['cep'] ?? '',
      logradouro: spaceDocument['logradouro'] ?? '',
      numero: spaceDocument['numero'] ?? '',
      bairro: spaceDocument['bairro'] ?? '',
      cidade: spaceDocument['cidade'] ?? '',
      selectedTypes: selectedTypes,
      selectedServices: selectedServices,
      averageRating: averageRating,
      numComments: numComments,
      locadorName: spaceDocument['locador_name'] ?? '',
      descricao: spaceDocument['descricao'] ?? '',
      city: spaceDocument['city'] ?? '',
      imagesUrl: imagesUrl,
      latitude: spaceDocument['latitude'] ?? 0.0,
      longitude: spaceDocument['longitude'] ?? 0.0,
      locadorAvatarUrl: spaceDocument['locadorAvatarUrl'] ?? '',
      startTime: spaceDocument['startTime'] ?? '',
      endTime: spaceDocument['endTime'] ?? '',
      days: days,
      preco: spaceDocument['preco'] ?? '',
      cnpjEmpresaLocadora: spaceDocument['cnpj_empresa_locadora'] ?? '',
      estado: spaceDocument['estado'] ?? '',
      locadorCpf: spaceDocument['locador_cpf'] ?? '',
      nomeEmpresaLocadora: spaceDocument['nome_empresa_locadora'] ?? '',
      locadorAssinatura: spaceDocument['locador_assinatura'] ?? '',
      numLikes: spaceDocument['num_likes'] ?? 0,
    );
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
  Future<DocumentSnapshot> getUserDocument(String userId) async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: userId).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0]; // Retorna o primeiro documento encontrado.
    }

    // Trate o caso em que nenhum usuário foi encontrado.
    //se esse erro ocorrer la numm metodo que chama getUsrDocument, o (e) do catch vai ter essa msg
    throw Exception("Usuário n encontrado");
  }

//retorna a lista de ids dos espaços favoritados pelo usuario
  Future<List<String>?> getUserFavoriteSpaces(String userId) async {
    final userDocument = await getUserDocument(userId);

    final userData = userDocument.data() as Map<String, dynamic>;

    if (userData.containsKey('spaces_favorite')) {
      return List<String>.from(userData['spaces_favorite'] ?? []);
    }

    return null;
  }
}

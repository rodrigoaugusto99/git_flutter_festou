import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/cupom_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';

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

  Row getAvatar(UserModel userModel) {
    return userModel.avatarUrl.isNotEmpty
        ? Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundImage: NetworkImage(userModel.avatarUrl),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        : Row(
            children: [
              CircleAvatar(
                radius: 27,
                child: userModel.name.isNotEmpty
                    ? Text(
                        userModel.name[0].toUpperCase(),
                        style: const TextStyle(fontSize: 25),
                      )
                    : const Icon(
                        Icons.person,
                        size: 40,
                      ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          );
  }

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
          fantasyName: data['fantasy_name'] ?? '',
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
          locador: data['locador'] ?? false,
        );
      }
    }
    return null;
  }

  Future<void> updateUserLocador(String userId, bool locador) async {
    try {
      QuerySnapshot querySnapshot =
          await usersCollection.where('uid', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        await userDoc.reference.update({'locador': locador});
      } else {
        throw Exception("Usuário não encontrado");
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Erro ao atualizar o usuário');
    }
  }

  Future<UserModel?> getCurrentUserModelById({required String id}) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('users').where('uid', isEqualTo: id).get();

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
        id: data['uid'] ?? '',
        avatarUrl: data['avatar_url'] ?? '',
        fantasyName: data['avatar_url'] ?? '',
        locador: data['locador'],
      );
    }

    return null;
  }

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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.id)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("User does not exist!");
      }

      DocumentSnapshot snapshot = querySnapshot.docs.first;

      List<dynamic> lastSeen = snapshot.get('last_seen') ?? [];

      lastSeen.remove(spaceId);

      lastSeen.insert(0, spaceId);

      if (lastSeen.length > 10) {
        lastSeen = lastSeen.sublist(0, 10);
      }

      await snapshot.reference.update({'last_seen': lastSeen});
    } catch (error) {
      log("Failed to update last seen: $error");
    }
  }

  Future<List<SpaceModel>?> getLastSeenSpaces() async {
    final user = await getCurrentUserModel();
    if (user != null) {
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
    List<String> selectedTypes =
        List<String>.from(spaceDocument['selectedTypes'] ?? []);
    List<String> selectedServices =
        List<String>.from(spaceDocument['selectedServices'] ?? []);
    List<String> imagesUrl =
        List<String>.from(spaceDocument['images_url'] ?? []);
    List<String> days = List<String>.from(spaceDocument['days'] ?? []);

    String spaceId = spaceDocument.get('space_id');
    final averageRating = await getAverageRating(spaceId);
    final numComments = await getNumComments(spaceId);

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
      videosUrl: List<String>.from(spaceDocument['videos'] ?? []),
    );
  }

  Future<String> getAverageRating(String spaceId) async {
    final spaceDocument =
        await spacesCollection.where('space_id', isEqualTo: spaceId).get();

    if (spaceDocument.docs.isNotEmpty) {
      String averageRatingValue = spaceDocument.docs.first['average_rating'];
      return averageRatingValue;
    }

    throw Exception("Espaço não encontrado");
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

  Future<DocumentSnapshot> getUserDocument(String userId) async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: userId).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0];
    }

    throw Exception("Usuário n encontrado");
  }

  Future<List<String>?> getUserFavoriteSpaces(String userId) async {
    final userDocument = await getUserDocument(userId);

    final userData = userDocument.data() as Map<String, dynamic>;

    if (userData.containsKey('spaces_favorite')) {
      return List<String>.from(userData['spaces_favorite'] ?? []);
    }

    return null;
  }
}

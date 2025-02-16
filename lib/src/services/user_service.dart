import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/models/cupom_model.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:festou/src/models/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

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
        return UserModel.fromMap(data..['id'] = userDoc.id);
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
      return UserModel.fromMap(data);
    }

    return null;
  }

  Future<CupomModel?> getCupom(String codigo) async {
    String codigoLower = codigo.toUpperCase();
    QuerySnapshot querySnapshot = await _firestore
        .collection('cupons')
        .where('codigo', isEqualTo: codigoLower)
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
          .where('uid', isEqualTo: user.uid)
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

  Future<List<SpaceModel>> getLastSeenSpaces() async {
    final user = await getCurrentUserModel();
    if (user != null) {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        throw Exception("User does not exist!");
      }

      DocumentSnapshot userDoc = userSnapshot.docs.first;
      List<dynamic> lastSeenIds = userDoc.get('last_seen') ?? [];

      final userSpacesFavorite = await getUserFavoriteSpaces(user.uid);

      List<Future<SpaceModel?>> futures = lastSeenIds.map((id) async {
        try {
          QuerySnapshot spaceQuerySnapshot = await FirebaseFirestore.instance
              .collection('spaces')
              .where('space_id', isEqualTo: id)
              .where('deletedAt', isNull: true)
              .limit(1)
              .get();

          if (spaceQuerySnapshot.docs.isEmpty) {
            return null; // Se o espaço foi deletado, apenas retorna null
          }

          QueryDocumentSnapshot spaceDoc = spaceQuerySnapshot.docs.first;
          bool isFavorited =
              userSpacesFavorite?.contains(spaceDoc['space_id']) ?? false;

          return mapSpaceDocumentToModel(spaceDoc, isFavorited);
        } catch (e) {
          log('Erro ao recuperar o espaço: $e');
          return null;
        }
      }).toList();

      List<SpaceModel> spaces =
          (await Future.wait(futures)).whereType<SpaceModel>().toList();

      return spaces;
    }

    return [];
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

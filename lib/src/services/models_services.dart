import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';

class ModelsServices {
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser!;

  Future<UserModel?> getUserModel(String userId) async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: userId).get();

    if (userDocument.docs.isNotEmpty) {
      final data = userDocument.docs.first.data();

      if (data is Map<String, dynamic>) {
        UserModel userModel = UserModel(
          data['email'] ?? '',
          data['name'] ?? '',
          data['cpf'] ?? '',
          data['user_address'] != null ? data['user_address']['cep'] ?? '' : '',
          data['user_address'] != null
              ? data['user_address']['logradouro'] ?? ''
              : '',
          data['telefone'] ?? '',
          data['user_address'] != null
              ? data['user_address']['bairro'] ?? ''
              : '',
          data['user_address'] != null
              ? data['user_address']['cidade'] ?? ''
              : '',
          userId,
          data['doc1_url'] ?? '',
          data['doc2_url'] ?? '',
          data['avatar_url'] ?? '',
        );

        return userModel;
      } else {
        return null;
      }
    }

    // Trate o caso em que nenhum documento foi encontrado.
    // throw Exception("Documento não encontrado");
    return null;
  }

  Future<SpaceModel?> getSpaceModel(String userId) async {
    final spaceDocumentt =
        await spacesCollection.where('uid', isEqualTo: userId).get();

    if (spaceDocumentt.docs.isNotEmpty) {
      final spaceDocument = spaceDocumentt.docs.first.data();

      if (spaceDocument is Map<String, dynamic>) {
        final userSpacesFavorite = await getUserFavoriteSpaces();
        final isFavorited =
            userSpacesFavorite?.contains(spaceDocument['space_id']) ?? false;

        SpaceModel spaceModel = SpaceModel(
          isFavorited,
          spaceDocument['space_id'] ?? '',
          spaceDocument['user_id'] ?? '',
          spaceDocument['titulo'] ?? '',
          spaceDocument['cep'] ?? '',
          spaceDocument['logradouro'] ?? '',
          spaceDocument['numero'] ?? '',
          spaceDocument['bairro'] ?? '',
          spaceDocument['cidade'] ?? '',
          spaceDocument['selectedTypes'] ?? '',
          spaceDocument['selectedServices'] ?? '',
          spaceDocument['average_rating'] ?? '',
          spaceDocument['num_comments'] ?? '',
          spaceDocument['locador_name'] ?? '',
          spaceDocument['descricao'] ?? '',
          spaceDocument['city'] ?? '',
          spaceDocument['images_url'] ?? '',
          spaceDocument['latitude'] ?? '',
          spaceDocument['longitude'] ?? '',
          spaceDocument['locadorAvatarUrl'] ?? '',
        );

        return spaceModel;
      } else {
        return null;
      }
    }

    // Trate o caso em que nenhum documento foi encontrado.
    // throw Exception("Documento não encontrado");
    return null;
  }

  Future<List<String>?> getUserFavoriteSpaces() async {
    final userDocument = await getUserDocument();

    final userData = userDocument.data() as Map<String, dynamic>;

    if (userData.containsKey('spaces_favorite')) {
      return List<String>.from(userData['spaces_favorite'] ?? []);
    }

    return null;
  }

  Future<DocumentSnapshot> getUserDocument() async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: user.uid).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0];
    }
    throw Exception("Usuário n encontrado");
  }
}

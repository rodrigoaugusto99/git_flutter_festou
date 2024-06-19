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
          email: data['email'] ?? '',
          name: data['name'] ?? '',
          cpfOuCnpj: data['cpf'] ?? '',
          cep: data['user_address']?['cep'] ?? '',
          logradouro: data['user_address']?['logradouro'] ?? '',
          telefone: data['telefone'] ?? '',
          bairro: data['user_address']?['bairro'] ?? '',
          cidade: data['user_address']?['cidade'] ?? '',
          id: userId,
          avatarUrl: data['avatar_url'] ?? '',
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
          isFavorited: isFavorited,
          spaceId: spaceDocument['space_id'] ?? '',
          userId: spaceDocument['user_id'] ?? '',
          titulo: spaceDocument['titulo'] ?? '',
          cep: spaceDocument['cep'] ?? '',
          logradouro: spaceDocument['logradouro'] ?? '',
          numero: spaceDocument['numero'] ?? '',
          bairro: spaceDocument['bairro'] ?? '',
          cidade: spaceDocument['cidade'] ?? '',
          selectedTypes: spaceDocument['selectedTypes'] ?? [],
          selectedServices: spaceDocument['selectedServices'] ?? [],
          averageRating: spaceDocument['average_rating'] ?? '',
          numComments: spaceDocument['num_comments'] ?? '',
          locadorName: spaceDocument['locador_name'] ?? '',
          descricao: spaceDocument['descricao'] ?? '',
          city: spaceDocument['city'] ?? '',
          imagesUrl: List<String>.from(spaceDocument['images_url'] ?? []),
          videosUrl: List<String>.from(spaceDocument['videos'] ?? []),
          latitude: spaceDocument['latitude'] ?? 0.0,
          longitude: spaceDocument['longitude'] ?? 0.0,
          locadorAvatarUrl: spaceDocument['locadorAvatarUrl'] ?? '',
          startTime: spaceDocument['startTime'] ?? '',
          endTime: spaceDocument['endTime'] ?? '',
          days: List<String>.from(spaceDocument['days'] ?? []),
          preco: spaceDocument['preco'] ?? '',
          cnpjEmpresaLocadora: spaceDocument['cnpj_empresa_locadora'] ?? '',
          estado: spaceDocument['estado'] ?? '',
          locadorCpf: spaceDocument['locador_cpf'] ?? '',
          nomeEmpresaLocadora: spaceDocument['nome_empresa_locadora'] ?? '',
          locadorAssinatura: spaceDocument['locador_assinatura'] ?? '',
          numLikes: spaceDocument['num_likes'] ?? 0,
        );

        return spaceModel;
      } else {
        return null;
      }
    }

    // Trate o caso em que nenhum documento foi encontrado.
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

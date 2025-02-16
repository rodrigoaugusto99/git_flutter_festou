import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:festou/src/models/user_model.dart';

class ModelsServices {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser!;

  Future<UserModel?> getUserModel(String userId) async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: userId).limit(1).get();

    if (userDocument.docs.isNotEmpty) {
      final data = userDocument.docs.first.data();

      if (data is Map<String, dynamic>) {
        UserModel userModel = UserModel.fromMap(data);

        return userModel;
      } else {
        return null;
      }
    }
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
        await usersCollection.where('uid', isEqualTo: user.uid).limit(1).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs.first;
    }
    throw Exception("Usuário não encontrado");
  }
}

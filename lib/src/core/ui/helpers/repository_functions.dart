import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RepositoryFunctions {
  static final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  static final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  static final user = FirebaseAuth.instance.currentUser!;

  static Future<DocumentSnapshot> getUserId() async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: user.uid).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0]; // Retorna o primeiro documento encontrado.
    }

    // Trate o caso em que nenhum usuário foi encontrado.
    throw Exception("Usuário não encontrado");
  }
}

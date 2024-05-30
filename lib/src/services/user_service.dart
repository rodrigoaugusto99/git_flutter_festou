import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
          cpf: data['cpf'] ?? '',
          cep: data['user_address']?['cep'] ?? '',
          logradouro: data['user_address']?['logradouro'] ?? '',
          telefone: data['telefone'] ?? '',
          bairro: data['user_address']?['bairro'] ?? '',
          cidade: data['user_address']?['cidade'] ?? '',
          id: firebaseUser.uid,
          doc1Url: data['doc1_url'] ?? '',
          doc2Url: data['doc2_url'] ?? '',
          avatarUrl: data['avatar_url'] ?? '',
        );
      }
    }
    return null;
  }
}

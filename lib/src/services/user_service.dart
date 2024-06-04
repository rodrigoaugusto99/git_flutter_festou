import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/models/cupom_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}

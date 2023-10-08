import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  static final FirebaseAuth auth = FirebaseAuth.instance;

  // Função para criar um documento de usuário no Firestore ao se cadastrar
  static Future<void> createUserInFirestore(User user) async {
    //criando variavel que aponta para esse documento específico do user
    final DocumentReference userDocRef = users.doc(user.uid);

    //Criando um mapa de dados "userData" com as informacoes do user
    // Dados do usuário a serem armazenados no Firestore
    Map<String, dynamic> userData = {
      'uid': user.uid,
      'email': user.email,
    };

    /*Inserindo os dados de userData no documento referenciado por userDocRef
  - Escreve os dados no Firestore.*/
    await userDocRef.set(userData);
  }

  //adicionando informações do usuario
  static Future<void> addUserInfos(String name, String number, String cep) {
    return users.add({
      'email': name,
      'number': number,
      'cep': cep,
    });
  }

//GET USERS FROM DATABASE
  static Stream<QuerySnapshot> getUsersStream() {
    final usersStream = users.snapshots();

    return usersStream;
  }

//UPDATE USER GIVEN A DOC ID
  static Future<void> updateUser(String docID, String newEmail) {
    return users.doc(docID).update({
      'email': newEmail,
    });
  }

  //DELETE USER GIVEN A DOC ID
  static Future<void> deleteUser(String docID) {
    return users.doc(docID).delete();
  }
}

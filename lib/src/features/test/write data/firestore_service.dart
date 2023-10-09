import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  static final FirebaseAuth auth = FirebaseAuth.instance;

  // Função para criar um documento de usuário no Firestore ao se cadastrar
  static Future<void> createUserInFirestore(User user) async {
    //criando variavel que aponta para esse documento específico do user
    final DocumentReference userDocRef = users.doc();

    //Criando um mapa de dados "userData" com as informacoes do user
    // Dados do usuário a serem armazenados no Firestore
    Map<String, dynamic> userData = {
      'uid': user.uid,
      'email': user.email,
      'user_infos': [],
      'user_spaces': [],
    };

    /*Inserindo os dados de userData no documento referenciado por userDocRef
  - Escreve os dados no Firestore.*/
    await userDocRef.set(userData);
  }

  //adicionando informações do usuario
  static Future<void> addUserInfos(User user, String name, String telefone,
      String cep, String logradouro, String bairro, String cidade) async {
    try {
      // Obtendo uma referência ao documento do usuário
      //o get retorna um querySnapshot,  e não uma referência direta ao documento(DocumentReference)
      QuerySnapshot querySnapshot =
          await users.where("uid", isEqualTo: user.uid).get();

      // Verificando se há exatamente um documento correspondente
      if (querySnapshot.docs.length == 1) {
        // Obtendo a referência do documento (único)
        DocumentReference userDocRef = querySnapshot.docs[0].reference;

// Adicionando informações de usuário diretamente ao array 'user_infos'
        // Adicionando informações de usuário ao array 'user_infos'
        await userDocRef.update({
          'user_infos.name': name,
          'user_infos.numero_de_telefone': telefone,
          'user_infos.user_address.cep': cep,
          'user_infos.user_address.logradouro': logradouro,
          'user_infos.user_address.bairro': bairro,
          'user_infos.user_address.cidade': cidade,
        });

        log('Informações de usuário adicionadas com sucesso!');
      } else if (querySnapshot.docs.isEmpty) {
        log('Usuário não encontrado.');
      } else {
        log('Mais de um documento correspondente encontrado. Trate conforme necessário.');
      }
    } catch (e) {
      log('Erro ao adicionar informações de usuário: $e');
    }
  }

  //adicionando endereco do usuario
  static Future<void> addUserAddress(User user, String cep, String logradouro,
      String numero, String bairro, String cidade) async {
    // Obtendo uma referência ao documento do usuário
    DocumentReference userDocRef = users.doc(user.uid);

// Adicionando informações de usuário ao array 'user_address'
    await userDocRef.update({
      'user_address': FieldValue.arrayUnion([
        {
          'cep': 'Nome do Usuário',
          'logradouro': '123456789',
          'numero': '12345678901',
          'bairro': '12345678901',
          'cidade': '12345678901',
        },
      ]),
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
}

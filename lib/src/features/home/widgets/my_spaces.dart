import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MySpaces extends StatefulWidget {
  const MySpaces({super.key});

  @override
  State<MySpaces> createState() => _MySpacesState();
}

final user = FirebaseAuth.instance.currentUser!;

final CollectionReference _usersStream =
    FirebaseFirestore.instance.collection('users');

class _MySpacesState extends State<MySpaces> {
  String email = '';
  String name = '';
  String cep = '';
  String logradouro = '';
  String numero = '';
  String bairro = '';
  String cidade = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logged in as: ${user.email}')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream.where('uid', isEqualTo: user.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Algo deu errado');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(), // Exibe um indicador de carregamento circular
            );
          }

          if (!snapshot.hasData) {
            // O documento não existe ou ainda não foi carregado
            return const Text('Documento do usuário não encontrado');
          }

          // Obtém o primeiro documento correspondente (deve ser único)
          final userDocument = snapshot.data!.docs.first;

          // Obtém os dados do documento atual como um mapa
          Map<String, dynamic> data =
              userDocument.data() as Map<String, dynamic>;

          // Obtém o valor associado à chave 'email' no mapa de dados
          String userEmail = data['email'];

//pegando mapa de user_infos
          Map<String, dynamic> userInfos =
              data['user_infos'] as Map<String, dynamic>;

//criando um mapa com os valores de user_infos
          Map<String, dynamic> mapInfos = {
            'name': userInfos['name'],
            'numero_de_telefone': userInfos['numero_de_telefone'],
          };

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email do usuário: $userEmail'),
                Text('Nome: ${mapInfos['name']}'),
                Text('Numero de telefone: ${mapInfos['numero_de_telefone']}'),
                //Text('Email do Espaço: ${mapSpaces['email']}'),
                //Text('Nome do Espaço: ${mapSpaces['name']}'),
                /*Text('CEP: $cep'),
                Text('Logradouro: $logradouro'),
                Text('Numero: $numero'),
                Text('Bairro: $bairro'),
                Text('Cidade: $cidade'),*/
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllSpaces extends StatefulWidget {
  const AllSpaces({super.key});

  @override
  State<AllSpaces> createState() => _AllSpacesState();
}

final user = FirebaseAuth.instance.currentUser!;

final _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

class _AllSpacesState extends State<AllSpaces> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logged in as: ${user.email}')),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Algo deu errado');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return const Text('Documento do usuário não encontrado');
            }

//pegando todos os documentos(Lista de QueryDocumentSnapshot)
            final userDocuments = snapshot.data!.docs;

            List<Widget> userWidgets = [];

            for (var userDocument in userDocuments) {
              //pega o email do documento que é string
              String userEmail = userDocument['email'];
              //pega o campo user_infos que é um mapa
              Map<String, dynamic> userInfos = userDocument['user_infos'];
              Map<String, dynamic> userAddress = userInfos['user_address'];
              //pega o campo user_spaces que é uma lista(de mapas)
              List<dynamic> userSpaces = userDocument['user_spaces'];

              List<Widget> spaceWidgets = [];

//pra cada documento(lista) lido, vamos ler os espaços(lista) dos documentos
              for (var space in userSpaces) {
                Map<String, dynamic> spaceAddress = space['space_address'];

                spaceWidgets.add(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Informações do Espaço:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    Text('Email do Espaço: ${space['emailComercial']}'),
                    Text('Nome do Espaço: ${space['nome_do_espaco']}'),
                    Text(
                        'Tipos Selecionados: ${space['space_infos']['selectedTypes'].join(', ')}'),
                    Text(
                        'Serviços Selecionados: ${space['space_infos']['selectedServices'].join(', ')}'),
                    Text(
                        'Dias Disponíveis: ${space['space_infos']['availableDays'].join(', ')}'),
                    const Text('Endereço:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('CEP: ${spaceAddress['cep']}'),
                    Text('Logradouro: ${spaceAddress['logradouro']}'),
                    Text('Número: ${spaceAddress['numero']}'),
                    Text('Bairro: ${spaceAddress['bairro']}'),
                    Text('Cidade: ${spaceAddress['cidade']}'),
                  ],
                ));
              }

              userWidgets.add(Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações do Usuário:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Text('Email: $userEmail'),
                    Text('Nome: ${userInfos['name']}'),
                    Text(
                        'Número de Telefone: ${userInfos['numero_de_telefone']}'),
                    Text('CEP: ${userAddress['cep']}'),
                    Text('Logradouro: ${userAddress['logradouro']}'),
                    Text('Bairro: ${userAddress['bairro']}'),
                    Text('Cidade: ${userAddress['cidade']}'),
                    ...spaceWidgets,
                  ],
                ),
              ));
            }
            return Column(
              children: userWidgets,
            );
          },
        ),
      ),
    );
  }
}

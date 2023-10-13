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
  List<Map<String, dynamic>> userSpacesList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logged in as: ${user.email}')),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream.where('uid', isEqualTo: user.uid).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            //email(String)
            String userEmail = data['email'];

            //pegando os dados do mapa de user_infos
            //user_infos(Map)
            Map<String, dynamic> userInfos =
                data['user_infos'] as Map<String, dynamic>;

            //criando um outro mapa com os valores de user_infos
            //user_infos.name .telefone
            Map<String, dynamic> mapUserInfos = {
              'name': userInfos['name'],
              'numero_de_telefone': userInfos['numero_de_telefone'],
              'bairro': userInfos['user_address']['bairro'],
              'logradouro': userInfos['user_address']['logradouro'],
              'cep': userInfos['user_address']['cep'],
              'cidade': userInfos['user_address']['cidade'],
            };
            // Recupere a lista de espaços do usuário
            //user_spaces(List)
            List<dynamic> userSpaces = data['user_spaces'];

            // Limpe a lista de espaços antes de preenchê-la para evitar duplicações
            userSpacesList.clear();

            // Itere pelos espaços e adicione cada espaço à lista
            //pegando todos os MAPAS da LISTA
            for (var space in userSpaces) {
              userSpacesList.add(space as Map<String, dynamic>);
            }

            /* Agora você pode acessar os espaços na lista userSpacesList
             userSpacesList[0] acessa o primeiro espaço, userSpacesList[1] 
             o segundo e assim por diante*/

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informações do Usuário:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                  Text('Email: $userEmail'),
                  Text('Nome: ${mapUserInfos['name']}'),
                  Text(
                      'Número de Telefone: ${mapUserInfos['numero_de_telefone']}'),
                  Text('CEP: ${mapUserInfos['cep']}'),
                  Text('logradouro: ${mapUserInfos['logradouro']}'),
                  Text('bairro: ${mapUserInfos['bairro']}'),
                  Text('cidade: ${mapUserInfos['cidade']}'),
                  for (var space in userSpacesList) ...[
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
                    Text('CEP: ${space['space_address']['cep']}'),
                    Text('Logradouro: ${space['space_address']['logradouro']}'),
                    Text('Número: ${space['space_address']['numero']}'),
                    Text('Bairro: ${space['space_address']['bairro']}'),
                    Text('Cidade: ${space['space_address']['cidade']}'),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [userSpacesList];
}

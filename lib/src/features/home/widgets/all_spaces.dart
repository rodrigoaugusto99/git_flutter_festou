import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card.dart';

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

            final userDocumentsAux = snapshot.data!.docs
                .where((doc) => doc['uid'] == user.uid)
                .toList();

/*como a lista terá apenas um documento, pegue o primeiro. */
            final userDocument = userDocumentsAux[0];

            // Obtenha a lista de espaços favoritos do usuário atual
            final List<dynamic> userSpacesFavorite =
                userDocument['spaces_favorite'] ?? [];

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

                final isFavorited =
                    userSpacesFavorite.contains(space['space_id']);

                spaceWidgets.add(SpaceCard(
                  isFavorited: isFavorited,
                  spaceId: space['space_id'],
                  spaceEmail: space['emailComercial'],
                  spaceName: space['nome_do_espaco'],
                  spaceCep: spaceAddress['cep'],
                  spaceLogradouro: spaceAddress['logradouro'],
                  spaceNumero: spaceAddress['numero'],
                  spaceBairro: spaceAddress['bairro'],
                  spaceCidade: spaceAddress['cidade'],
                  selectedTypes: space['space_infos']['selectedTypes'],
                  selectedServices: space['space_infos']['selectedServices'],
                  availableDays: space['space_infos']['availableDays'],
                  userEmail: userEmail,
                  userTelefone: userInfos['name'],
                  userName: userInfos['numero_de_telefone'],
                  userCep: userAddress['cep'],
                  userLogradouro: userAddress['logradouro'],
                  userBairro: userAddress['bairro'],
                  userCidade: userAddress['cidade'],
                  userId: '',
                ));
              }

              userWidgets.add(Column(
                children: [
                  ...spaceWidgets,
                ],
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

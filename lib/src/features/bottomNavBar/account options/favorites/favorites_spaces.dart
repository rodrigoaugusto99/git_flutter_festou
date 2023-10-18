import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card.dart';

class FavoriteSpacesPage extends StatefulWidget {
  const FavoriteSpacesPage({super.key});

  @override
  State<FavoriteSpacesPage> createState() => _FavoriteSpacesPageState();
}

final user = FirebaseAuth.instance.currentUser!;

final userId = user.uid;

final _usersStream = FirebaseFirestore.instance.collection('users').snapshots();

class _FavoriteSpacesPageState extends State<FavoriteSpacesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logged in as: ${user.email}\nFavorites')),
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

            /*criando uma lista com os documentos que tem o uid
            igual ao userId
            (tem que ser assim pois o where retorna um iterable
            de documentos) */
            final userDocumentsAux = snapshot.data!.docs
                .where((doc) => doc['uid'] == userId)
                .toList();

/*como a lista terá apenas um documento, pegue o primeiro. */
            final userDocument = userDocumentsAux[0];

            // Obtenha a lista de espaços favoritos do usuário atual
            final List<dynamic> userSpacesFavorite =
                userDocument['spaces_favorite'] ?? [];

            List<Widget> userWidgets = [];

            for (var userDocument in userDocuments) {
              String userEmail = userDocument['email'];
              Map<String, dynamic> userInfos = userDocument['user_infos'];
              Map<String, dynamic> userAddress = userInfos['user_address'];
              List<dynamic> userSpaces = userDocument['user_spaces'];

              List<Widget> spaceWidgets = [];

              for (var space in userSpaces) {
                Map<String, dynamic> spaceAddress = space['space_address'];

                final isFavorited =
                    userSpacesFavorite.contains(space['space_id']);

                if (isFavorited) {
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

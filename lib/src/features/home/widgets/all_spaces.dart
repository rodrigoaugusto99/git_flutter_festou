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

final _spacesStream =
    FirebaseFirestore.instance.collection('spaces').snapshots();

class _AllSpacesState extends State<AllSpaces> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logged in as: ${user.email}')),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _spacesStream,
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
            final spaceDocuments = snapshot.data!.docs;

            List<Widget> spaceWidgets = [];

            for (var space in spaceDocuments) {
              spaceWidgets.add(SpaceCard(
                isFavorited: false,
                spaceId: space['space_id'],
                spaceEmail: space['email_do_espaço'],
                spaceName: space['nome_do_espaco'],
                spaceCep: space['cep'],
                spaceLogradouro: space['logradouro'],
                spaceNumero: space['numero'],
                spaceBairro: space['bairro'],
                spaceCidade: space['cidade'],
                selectedTypes: space['selectedTypes'],
                selectedServices: space['selectedServices'],
                availableDays: space['availableDays'],
                userId: '',
              ));
            }
            return Column(
              children: spaceWidgets,
            );
          },
        ),
      ),
    );
  }
}

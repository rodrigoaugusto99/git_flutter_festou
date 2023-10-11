import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 5,
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'Espaço Alegria Kids',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            Text(
              'Rua Maria da Graça, 123, Maria da graça - RJ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(logoutProvider.future);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.brown,
        onPressed: () {
          Navigator.of(context).pushNamed('/register/space');
        },
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Meus espaços cadastrados\nLogged in as: ${user.email}'),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(), // Exibe um indicador de carregamento circular
                  );
                }
                /*pegando todos os documentos*/
                List docsList = snapshot.data!.docs;

                return ListView.builder(
                  // Define o ListView para usar apenas o espaço necessário
                  shrinkWrap: true,
                  // Impede a rolagem do ListView
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docsList.length,
                  itemBuilder: (context, index) {
                    /*pegando cada documento(até o index acabar)*/
                    DocumentSnapshot document = docsList[index];
                    /*Obtém o ID do documento atual
                    - pode ser usado para editar ou deletar esse documento.*/
                    String docID = document.id;
                    /*Obtém os dados do documento atual como um mapa*/
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    /*Obtém o valor associado à chave 'email' no mapa de dados */
                    String emailText = data['email'];
                    /*Obtém o valor associado à chave 'uid' no mapa de dados */
                    String uidText = data['uid'];
                    return const SpaceCard();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

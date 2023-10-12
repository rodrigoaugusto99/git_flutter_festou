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

  final query = FirebaseFirestore.instance
      .collection('users')
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid);

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
                      Text('Logged in as: ${user.email}'),
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed('/home/my_spaces', arguments: user),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Cor da borda
                              width: 2.0, // Largura da borda
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(10.0)), // Raio da borda
                          ),
                          child: const Text(
                            'Meus espaços cadastrados',
                            style: TextStyle(fontSize: 11),
                          ),
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

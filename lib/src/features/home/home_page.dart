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
      backgroundColor: Colors.white,
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
            expandedHeight: 142.0, // ajuste esse valor conforme necessário
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Lista horizontal de botões
                    SizedBox(
                      height: 80.0, // Defina a altura apropriada para os botões
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                            width: 100.0,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Kids'),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Espaçamento entre os botões
                          SizedBox(
                            width: 110.0,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Casamento'),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Espaçamento entre os botões
                          SizedBox(
                            width: 100.0,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Debutante'),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Espaçamento entre os botões
                          SizedBox(
                            width: 100.0,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Batismo'),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Espaçamento entre os botões
                          SizedBox(
                            width: 100.0,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Chá'),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Espaçamento entre os botões
                          SizedBox(
                            width: 100.0,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Reunião'),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Espaçamento entre os botões
                          SizedBox(
                            width: 100.0,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Outros'),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Espaçamento entre os botões
                          // ... adicione mais botões conforme necessário
                        ],
                      ),
                    ),
                    const SizedBox(
                        height:
                            10), // Espaçamento entre a lista de botões e o resto do conteúdo
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('Logged in as: ${user.email}')),
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed('/home/my_spaces', arguments: user),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: const Expanded(
                              child: Text(
                                'Meus espaços cadastrados',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            pinned: false,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const SliverToBoxAdapter(
                    child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              List docsList = snapshot.data!.docs;

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    DocumentSnapshot document = docsList[index];
                    String docID = document.id;
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String emailText = data['email'];
                    String uidText = data['uid'];
                    return const SpaceCard();
                  },
                  childCount: docsList.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

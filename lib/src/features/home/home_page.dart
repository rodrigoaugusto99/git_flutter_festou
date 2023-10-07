import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/features/home/home_vm.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card.dart';
import 'package:git_flutter_festou/src/features/test/firebase_teste3.dart';
import 'package:git_flutter_festou/src/models/space/space_model_test2.dart';

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
              ref.read(homeVmProvider.notifier).logout();
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
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImageConstants.ballsBackground),
              fit: BoxFit.cover),
        ),
        child: CustomScrollView(
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
                        const Text('Meus espaços cadastrados'),
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
              child: Text(
                'Logged in as: ${user.email}',
                style: const TextStyle(color: Colors.black),
              ),
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

                  return ListView(
                    // Define o ListView para usar apenas o espaço necessário
                    shrinkWrap: true,
                    // Impede a rolagem do ListView
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return ListTile(
                            title: Text(data['email']),
                            subtitle: Text(data['uid']),
                          );
                        })
                        .toList()
                        .cast(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

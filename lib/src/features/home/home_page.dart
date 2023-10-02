import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/features/home/home_vm.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card.dart';
import 'package:git_flutter_festou/src/models/space/space_model_test.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    SpaceModelTest space = SpaceModelTest(
      name: 'rodrigo',
      email: 'email',
      cep: '22221000',
      endereco: 'endereco',
      numero: '123',
      bairro: 'catete',
      cidade: 'rio de janeiro',
      selectedTypes: ['type 1', 'type 2'],
      availableDays: ['Seg', 'Ter', 'Sex', 'Sab'],
      selectedServices: ['Service 1', 'Service 2', 'Service 3'],
      feedbacks: [],
    );
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpaceCard(space: space),
                  );
                },
                childCount: 6,
              ),
            )
          ],
        ),
      ),
    );
  }
}

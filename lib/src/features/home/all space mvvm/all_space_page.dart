import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/home/all%20space%20mvvm/all_spaces_state.dart';
import 'package:git_flutter_festou/src/features/home/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card2.dart';

class AllSpacePage extends ConsumerStatefulWidget {
  const AllSpacePage({super.key});

  @override
  ConsumerState<AllSpacePage> createState() => _AllSpacePageState();
}

class _AllSpacePageState extends ConsumerState<AllSpacePage> {
  @override
  @override
  Widget build(BuildContext context) {
    final spaces = ref.watch(allSpacesVmProvider);
    log('$spaces');

    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Logged in as: ${FirebaseAuth.instance.currentUser!.email}')),
      body: spaces.when(
        data: (AllSpaceState data) {
          return CustomScrollView(
            slivers: [
              //paras colocar widgets nao rolaveis.
              const SliverToBoxAdapter(
                child: Text('Spaces'),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => Column(
                          children: [
                            const Text('alo'),
                            SpaceCard2(space: data.spaces[index]),
                          ],
                        ),
                    childCount: data.spaces.length),
              ),
            ],
          );
        },
        error: (Object error, StackTrace stackTrace) {
          return const Center(
            child: Text('Erro'),
          );
        },
        loading: () {
          return const Center(
            child: Text('Loading'),
          );
        },
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/home/my%20favorite%20spaces%20mvvm/my_favorite_spaces_state.dart';
import 'package:git_flutter_festou/src/features/home/my%20favorite%20spaces%20mvvm/my_favorite_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card2.dart';

class MyFavoriteSpacePage extends ConsumerStatefulWidget {
  const MyFavoriteSpacePage({super.key});

  @override
  ConsumerState<MyFavoriteSpacePage> createState() =>
      _MyFavoriteSpacePageState();
}

class _MyFavoriteSpacePageState extends ConsumerState<MyFavoriteSpacePage> {
  @override
  Widget build(BuildContext context) {
    final favSpaces = ref.watch(myFavoriteSpacesVmProvider);

    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Logged in as: ${FirebaseAuth.instance.currentUser!.email}')),
      body: favSpaces.when(
        data: (MyFavoriteSpacesState data) {
          return CustomScrollView(
            slivers: [
              //paras colocar widgets nao rolaveis.
              const SliverToBoxAdapter(
                child: Center(
                    child: Text(
                  'MY FAVORITE SPACES',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => Column(
                          children: [SpaceCard2(space: data.spaces[index])],
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

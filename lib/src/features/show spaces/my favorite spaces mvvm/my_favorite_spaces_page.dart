import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/widgets/my_sliver_list_normal.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/widgets/my_sliver_to_box_adapter.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/my%20favorite%20spaces%20mvvm/my_favorite_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/my%20favorite%20spaces%20mvvm/my_favorite_spaces_vm.dart';

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

    final message = ref.watch(myFavoriteSpacesVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (message.toString() != '') {
        Messages.showError(message, context);
      }
    });

    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Logged in as: ${FirebaseAuth.instance.currentUser!.email}')),
      body: favSpaces.when(
        data: (MyFavoriteSpacesState data) {
          return CustomScrollView(
            slivers: [
              const MySliverToBoxAdapter(
                text: 'MY FAVORITE SPACES',
              ),
              MySliverListNormal(data: data, spaces: favSpaces),
            ],
          );
        },
        error: (Object error, StackTrace stackTrace) {
          return const Stack(children: [
            Center(child: Text('Inserir imagem melhor papai')),
            Center(child: Icon(Icons.error)),
          ]);
        },
        loading: () {
          return const Stack(children: [
            Center(child: Text('Inserir carregamento Personalizado papai')),
            Center(child: CircularProgressIndicator()),
          ]);
        },
      ),
    );
  }
}

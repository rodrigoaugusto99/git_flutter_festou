import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/my%20favorite%20spaces%20mvvm/my_favorite_spaces_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/my%20favorite%20spaces%20mvvm/my_favorite_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/custom_app_bar.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/my_sliver_list_to_card_info.dart';

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
        title: const Text('Meus espacos favoritos'),
      ),
      body: favSpaces.when(
        data: (MyFavoriteSpacesState data) {
          return CustomScrollView(
            slivers: [
              MySliverListToCardInfo(
                data: data,
                spaces: favSpaces,
                x: true,
              ),
            ],
          );
        },
        error: (Object error, StackTrace stackTrace) {
          return const Stack(children: [
            Center(child: Icon(Icons.error)),
          ]);
        },
        loading: () {
          return const Stack(children: [
            Center(child: CustomLoadingIndicator()),
          ]);
        },
      ),
    );
  }
}

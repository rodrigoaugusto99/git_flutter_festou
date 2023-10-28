import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/widgets/my_sliver_list.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/widgets/my_sliver_to_box_adapter.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/my%20space%20mvvm/my_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/my%20space%20mvvm/my_spaces_vm.dart';

class MySpacesPage extends ConsumerStatefulWidget {
  const MySpacesPage({super.key});

  @override
  ConsumerState<MySpacesPage> createState() => _MySpacesPageState();
}

class _MySpacesPageState extends ConsumerState<MySpacesPage> {
  @override
  Widget build(BuildContext context) {
    final mySpaces = ref.watch(mySpacesVmProvider);

    final errorMessager = ref.watch(mySpacesVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (errorMessager.toString() != '') {
        Messages.showError(errorMessager, context);
      }
    });

    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Logged in as: ${FirebaseAuth.instance.currentUser!.email}')),
      body: mySpaces.when(
        data: (MySpacesState data) {
          return CustomScrollView(
            slivers: [
              const MySliverToBoxAdapter(
                text: 'MY SPACES',
              ),
              MySliverList(data: data, spaces: mySpaces),
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

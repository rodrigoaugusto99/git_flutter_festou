import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/home/all%20space%20mvvm/all_spaces_state.dart';
import 'package:git_flutter_festou/src/features/home/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_card.dart';

class AllSpacesPage extends ConsumerStatefulWidget {
  const AllSpacesPage({super.key});

  @override
  ConsumerState<AllSpacesPage> createState() => _AllSpacesPageState();
}

class _AllSpacesPageState extends ConsumerState<AllSpacesPage> {
  @override
  Widget build(BuildContext context) {
    final spaces = ref.watch(allSpacesVmProvider);

    final message = ref.watch(allSpacesVmProvider.notifier).errorMessage;

/*como nao pode chamar esse Messages durante o build, o future.delayed
chama quando termina o build */
    Future.delayed(Duration.zero, () {
      if (message.toString() != '') {
        Messages.showError(message, context);
      }
    });

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
                child: Center(
                    child: Text(
                  'ALL SPACES',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => Column(
                          children: [
                            SpaceCard2(space: data.spaces[index]),
                          ],
                        ),
                    childCount: data.spaces.length),
              ),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/surrounding%20spaces/surrounding_spaces_state.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/surrounding%20spaces/surrounding_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/my_sliver_list_normal.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/my_sliver_to_box_adapter.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';

class SurroundingSpacesPage extends ConsumerStatefulWidget {
  const SurroundingSpacesPage({super.key});

  @override
  ConsumerState<SurroundingSpacesPage> createState() =>
      _SurroundingSpacesPageState();
}

//TODO: spaces by surrounding area

class _SurroundingSpacesPageState extends ConsumerState<SurroundingSpacesPage> {
  @override
  Widget build(BuildContext context) {
    final allSpaces = ref.watch(surroundingSpacesVmProvider);

    final message = ref.watch(allSpacesVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (message.toString() != '') {
        Messages.showError(message, context);
      }
    });

    return Scaffold(
      body: allSpaces.when(
        data: (SurroundingSpacesState data) {
          return CustomScrollView(
            slivers: [
              const MySliverToBoxAdapter(
                text: 'ALL SPACES',
              ),
              MySliverListNormal(data: data, spaces: allSpaces),
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

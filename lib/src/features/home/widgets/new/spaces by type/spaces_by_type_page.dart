import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/spaces%20by%20type/spaces_by_type_state.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/spaces%20by%20type/spaces_by_type_vm.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/spaces%20with%20sugestion/spaces_with_sugestion_vm.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/widgets/my_sliver_list.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/widgets/my_sliver_to_box_adapter.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';

class SpacesByTypePage extends ConsumerStatefulWidget {
  const SpacesByTypePage({super.key});

  @override
  ConsumerState<SpacesByTypePage> createState() => _SpacesByTypePageState();
}

//TODO: spacs by type

class _SpacesByTypePageState extends ConsumerState<SpacesByTypePage> {
  @override
  Widget build(BuildContext context) {
    final typeSpaces = ref.watch(spacesByTypeVmProvider);

    final message = ref.watch(allSpacesVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (message.toString() != '') {
        Messages.showError(message, context);
      }
    });

    return Scaffold(
      body: typeSpaces.when(
        data: (SpacesByTypeState data) {
          return CustomScrollView(
            slivers: [
              const MySliverToBoxAdapter(
                text: 'ALL SPACES',
              ),
              MySliverList(data: data, spaces: typeSpaces),
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

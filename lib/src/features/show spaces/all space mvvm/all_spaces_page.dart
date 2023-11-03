import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/my_sliver_list_normal.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/widgets/my_sliver_to_box_adapter.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';

class AllSpacesPage extends ConsumerStatefulWidget {
  const AllSpacesPage({super.key});

  @override
  ConsumerState<AllSpacesPage> createState() => _AllSpacesPageState();
}

//TODO: spacs by type

class _AllSpacesPageState extends ConsumerState<AllSpacesPage> {
  @override
  Widget build(BuildContext context) {
    final allSpaces = ref.watch(allSpacesVmProvider);

    final message = ref.watch(allSpacesVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (message.toString() != '') {
        Messages.showError(message, context);
      }
    });

    return Scaffold(
      body: allSpaces.when(
        data: (AllSpaceState data) {
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/my_sliver_list_to_card_info.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/filter/filter_and_order_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20by%20type/spaces_by_type_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20by%20type/spaces_by_type_vm.dart';

class SpacesByTypePage extends ConsumerStatefulWidget {
  final List<String> type;
  const SpacesByTypePage({super.key, required this.type});

  @override
  ConsumerState<SpacesByTypePage> createState() => _SpacesByTypePageState();
}

class _SpacesByTypePageState extends ConsumerState<SpacesByTypePage> {
  @override
  Widget build(BuildContext context) {
    //recebendo os espaços por tipo
    final typeSpaces = ref.watch(spacesByTypeVmProvider(widget.type));
//recebendo espaços filtrados

    final message =
        ref.watch(spacesByTypeVmProvider(widget.type).notifier).errorMessage;

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
              //AppBar com botao p/ filtrar
              const FilterAndOrderPage(),
              const SliverToBoxAdapter(
                child: Text('SPACES BY TYPE'),
              ),
              MySliverListToCardInfo(
                data: data,
                spaces: typeSpaces,
                x: true,
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

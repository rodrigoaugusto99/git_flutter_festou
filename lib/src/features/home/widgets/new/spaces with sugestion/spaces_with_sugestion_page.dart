import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/home/widgets/card_infos.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/new_space_card.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/spaces%20with%20sugestion/spaces_with_sugestion_state.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/spaces%20with%20sugestion/spaces_with_sugestion_vm.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/widgets/my_sliver_list_normal.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/widgets/my_sliver_list_to_card_info.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/widgets/my_sliver_to_box_adapter.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:git_flutter_festou/src/models/space_with_image_model.dart';

class SpacesWithSugestionPage extends ConsumerStatefulWidget {
  final SpaceWithImages space;
  const SpacesWithSugestionPage({super.key, required this.space});

  @override
  ConsumerState<SpacesWithSugestionPage> createState() =>
      _SpacesWithSugestionPageState();
}

//TODO: space with sugestion

class _SpacesWithSugestionPageState
    extends ConsumerState<SpacesWithSugestionPage> {
  @override
  Widget build(BuildContext context) {
    final sugestions = ref.watch(spacesWithSugestionVmProvider(widget.space));

    final message = ref.watch(allSpacesVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (message.toString() != '') {
        log('message');
        Messages.showError(message, context);
      }
    });

    return Scaffold(
      body: sugestions.when(
        data: (SpacesWithSugestionState data) {
          return CustomScrollView(
            slivers: [
              //aqui, o space, ao ser clicao, vai retornar o card_info.
              SliverToBoxAdapter(
                  child: InkWell(
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CardInfos(space: widget.space),
                            ),
                          ),
                      child: NewSpaceCard(space: widget.space))),
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    color: Colors.black,
                    child: const Text(
                      'SUGESTÕES',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),

              MySliverListToCardInfo(data: data, spaces: sugestions),
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

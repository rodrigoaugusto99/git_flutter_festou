import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/my_sliver_list_to_card_info.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20with%20sugestion/spaces_with_sugestion_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20with%20sugestion/spaces_with_sugestion_vm.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class SpacesWithSugestionPage extends ConsumerStatefulWidget {
  final SpaceModel space;

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
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            elevation: 0,
            foregroundColor: innerBoxIsScrolled ? Colors.black : Colors.white,
            backgroundColor:
                innerBoxIsScrolled ? Colors.white : Colors.deepPurple[700],
            snap: true,
            floating: true,
            pinned: false,
          )
        ],
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
                                    NewCardInfo(space: widget.space),
                              ),
                            ),
                        child: NewSpaceCard(
                          hasHeart: true,
                          space: widget.space,
                          isReview: false,
                        ))),
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

                MySliverListToCardInfo(
                  data: data,
                  spaces: sugestions,
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
      ),
    );
  }
}

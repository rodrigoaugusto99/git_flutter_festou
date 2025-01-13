import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/my_sliver_list_to_card_info.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20with%20sugestion/spaces_with_sugestion_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/spaces%20with%20sugestion/spaces_with_sugestion_vm.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/notificacoes_page.dart';
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

    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Festou!',
                  style: TextStyle(
                      fontFamily: 'RedHatDisplay',
                      fontSize: 18,
                      color: Colors.blueGrey[500],
                      fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2.0), // Espaçamento entre os textos
                Text(
                  '${DateTime.now().year} - Todos os direitos reservados.',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text(
              'Novidade',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            actions: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(right: 20.0, top: 5.0, bottom: 5.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificacoesLocatarioPage(),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                      top: 10, left: 10, right: 10, bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            centerTitle: true,
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            snap: true,
            floating: true,
            pinned: false,
          )
        ],
        body: sugestions.when(
          data: (SpacesWithSugestionState data) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomScrollView(
                slivers: [
                  //aqui, o space, ao ser clicao, vai retornar o card_info.
                  SliverToBoxAdapter(
                      child: InkWell(
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewCardInfo(
                                      spaceId: widget.space.spaceId),
                                ),
                              ),
                          child: NewSpaceCard(
                            hasHeart: true,
                            space: widget.space,
                            isReview: false,
                          ))),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.only(left: x * 0.02, top: y * 0.02),
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: const Text(
                        'Sugeridos para você!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),

                  MySliverListToCardInfo(
                    spaces: data.spaces,
                    x: true,
                  ),
                ],
              ),
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
      ),
    );
  }
}

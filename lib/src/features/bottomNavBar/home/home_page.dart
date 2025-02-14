import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/app_bar_home.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/cupons_e_promocoes.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/feed_noticias.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/menu_space_types.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/search_button.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/my_last_seen_spaces.dart';
import 'package:festou/src/features/show%20spaces/surrounding%20spaces/surrounding_spaces_page.dart';

class HomePage extends ConsumerStatefulWidget {
  final String? previousRoute;

  const HomePage({this.previousRoute, super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final allSpaces = ref.watch(allSpacesVmProvider);

    final message = ref.watch(allSpacesVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (message.toString() != '') {
        Messages.showError(message, context);
      }
    });

    final fadeInDuration = (widget.previousRoute == '/home/search_page')
        ? const Duration(milliseconds: 400)
        : Duration.zero;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        body: allSpaces.when(
          data: (AllSpaceState data) {
            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                    child: SizedBox(
                  height: 20,
                )),
                const AppBarHome(),
                const SliverToBoxAdapter(
                    child: SizedBox(
                  height: 20,
                )),
                const SliverToBoxAdapter(
                  child: MenuSpaceTypes(),
                ),
                SliverToBoxAdapter(
                  child: SearchButton(
                    fadeInDuration: fadeInDuration,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text('Feed de notícias'),
                        // Text(
                        //   'Ver posts já visualizados',
                        //   style: TextStyle(
                        //     decoration: TextDecoration.underline,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: FeedNoticias(),
                ),
                const SliverToBoxAdapter(child: MyLastSeenSpaces()),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                    child: Text('Cupons e promoções'),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: CuponsEPromocoes(),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                    child: Text('Feed de notícias'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SurroundingSpacesPage(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Image.asset(
                            'lib/assets/images/imagem_terra.png',
                            width: 200,
                            height: 200,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Clique no globo para buscar espaços no mapa',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
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
      ),
    );
  }
}

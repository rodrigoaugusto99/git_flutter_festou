import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/app_bar_home.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/menu_space_types.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/search_button.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/my_last_seen_spaces.dart';

class HomePage extends ConsumerStatefulWidget {
  final String? previousRoute;

  const HomePage({this.previousRoute, Key? key}) : super(key: key);

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

    //final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;

    final fadeInDuration = (widget.previousRoute == '/home/search_page')
        ? const Duration(milliseconds: 400)
        : Duration.zero;
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.brown,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const EspacoRegisterPage(); // Substitua NovaPagina com o widget da sua nova tela
                },
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: allSpaces.when(
          data: (AllSpaceState data) {
            return CustomScrollView(
              slivers: [
                const AppBarHome(),
                const SliverToBoxAdapter(
                  child: MenuSpaceTypes(),
                ),
                SliverToBoxAdapter(
                  child: SearchButton(
                    fadeInDuration: fadeInDuration,
                  ),
                ),
                SliverToBoxAdapter(
                    child: MyLastSeenSpaces(
                  data: data,
                  spaces: allSpaces,
                )),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Espaços perto de você'),
                      SizedBox(
                        height: y * 0.21,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: Colors.grey,
                                width: 300,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('GIFS'),
                      SizedBox(
                        height: y * 0.31,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: Colors.grey,
                                width: 300,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          error: (Object error, StackTrace stackTrace) {
            return const Stack(children: [
              Center(child: Text('ish deu erro')),
              Center(child: Icon(Icons.error)),
            ]);
          },
          loading: () {
            return const Stack(children: [
              Center(child: Text('Inserir carregamento Personalizado papai')),
              Center(child: CircularProgressIndicator()),
            ]);
          },
        ));
  }
}

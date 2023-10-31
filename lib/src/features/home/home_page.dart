import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/home/widgets/app_bar_home.dart';
import 'package:git_flutter_festou/src/features/home/widgets/menu_space_types.dart';
import 'package:git_flutter_festou/src/features/home/widgets/new/spaces%20with%20sugestion/spaces_with_sugestion_page.dart';
import 'package:git_flutter_festou/src/features/home/widgets/search_button.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_buttons.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_page.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/widgets/my_sliver_list.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/widgets/my_sliver_to_box_adapter.dart';

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

    final fadeInDuration = (widget.previousRoute == '/home/search_page')
        ? const Duration(milliseconds: 400)
        : Duration.zero;
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.brown,
          onPressed: () {
            Navigator.of(context).pushNamed('/register/space');
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
                  child: SearchButton(fadeInDuration: fadeInDuration),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Vistos recentemente'),
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: Colors.grey,
                                width: 200,
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
                      const Text('Espaços perto de você'),
                      SizedBox(
                        height: 140,
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
                const MySliverToBoxAdapter(
                  text: 'ALL SPACES',
                ),
                MySliverList(data: data, spaces: allSpaces),
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
        ));
  }
}

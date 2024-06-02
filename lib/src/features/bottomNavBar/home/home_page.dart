import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/app_bar_home.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/menu_space_types.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/search_button.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/my_last_seen_spaces.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/surrounding%20spaces/surrounding_spaces_page.dart';
import 'package:lottie/lottie.dart';

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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SurroundingSpacesPage(),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 200, // Altura desejada

                        child: Transform.scale(
                          scale: 3,
                          child: Lottie.asset(
                            'lib/assets/animations/earth1.json',
                            fit: BoxFit.cover,
                            animate: false,
                          ),
                        ),
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
          )),
    );
  }
}

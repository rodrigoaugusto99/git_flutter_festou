import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/my_sliver_list_to_card_info.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/my%20space%20mvvm/my_spaces_state.dart';
import 'package:git_flutter_festou/src/features/show%20spaces/my%20space%20mvvm/my_spaces_vm.dart';

class MySpacesPage extends ConsumerStatefulWidget {
  const MySpacesPage({super.key});

  @override
  ConsumerState<MySpacesPage> createState() => _MySpacesPageState();
}

class _MySpacesPageState extends ConsumerState<MySpacesPage> {
  @override
  Widget build(BuildContext context) {
    final mySpaces = ref.watch(mySpacesVmProvider);

    final errorMessager = ref.watch(mySpacesVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (errorMessager.toString() != '') {
        Messages.showError(errorMessager, context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                //color: Colors.white.withOpacity(0.7),
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
        title: const Text(
          'Meus espaços',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: mySpaces.when(
        data: (MySpacesState data) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewSpaceRegister(),
                        ),
                      );
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        alignment: Alignment.center,
                        margin:
                            const EdgeInsets.only(left: 70, right: 70, top: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: const Color.fromARGB(255, 209, 139, 221)),
                        child: const Text(
                          'Cadastre um espaco',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
              ),
              MySliverListToCardInfo(
                data: data,
                spaces: mySpaces,
                x: false,
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
    );
  }
}

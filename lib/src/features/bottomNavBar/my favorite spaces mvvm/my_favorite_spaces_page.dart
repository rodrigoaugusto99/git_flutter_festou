import 'package:festou/src/features/bottomNavBar/search/search_page.dart';
import 'package:flutter/material.dart';

import 'package:festou/src/features/bottomNavBar/my%20favorite%20spaces%20mvvm/my_favorite_spaces_vm.dart';
import 'package:festou/src/features/loading_indicator.dart';

import 'package:festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:festou/src/features/space%20card/widgets/notificacoes_page.dart';
import 'package:lottie/lottie.dart';

class MyFavoriteSpacePage extends StatefulWidget {
  const MyFavoriteSpacePage({super.key});

  @override
  State<MyFavoriteSpacePage> createState() => _MyFavoriteSpacePageState();
}

class _MyFavoriteSpacePageState extends State<MyFavoriteSpacePage> {
  MyFavoriteSpacesVm viewModel = MyFavoriteSpacesVm();
  @override
  void initState() {
    super.initState();
    viewModel.addListener(_onViewModelChanged);
    viewModel.init();
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/background_favoritos.png',
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
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
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NotificacoesPage(locador: false),
                        ),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
              surfaceTintColor: Colors.transparent,
              centerTitle: true,
              title: const Text(
                'Favoritos',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: !viewModel.isLoading
                ? viewModel.allSpaces == null || viewModel.allSpaces!.isEmpty
                    ? Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Lottie.asset(
                                'lib/assets/animations/heart_break.json',
                                width: 150,
                                height: 150,
                                repeat: false,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Você ainda não possui espaços favoritos!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Explore os espaços disponíveis e marque seus favoritos para acessá-los facilmente.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(height: 25),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SearchPage(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.search,
                                    color: Colors.white),
                                label: const Text('Explorar Espaços'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 1000,
                        child: ListView.builder(
                          itemCount: viewModel.allSpaces!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewCardInfo(
                                      spaceId:
                                          viewModel.allSpaces![index].spaceId),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: NewSpaceCard(
                                  hasHeart: true,
                                  space: viewModel.allSpaces![index],
                                  isReview: false,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                : const Center(child: CustomLoadingIndicator()),
          ),
        ],
      ),
    );
  }
}

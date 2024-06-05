import 'package:flutter/material.dart';

import 'package:git_flutter_festou/src/features/bottomNavBar/my%20favorite%20spaces%20mvvm/my_favorite_spaces_vm.dart';

import 'package:git_flutter_festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Favoritos',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: !viewModel.isLoading
          ? viewModel.allSpaces == null
              ? const Center(
                  child: Text('Você não tem espaços favoritos'),
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
                            builder: (context) =>
                                NewCardInfo(space: viewModel.allSpaces![index]),
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
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

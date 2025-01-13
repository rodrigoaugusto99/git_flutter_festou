import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:git_flutter_festou/src/features/bottomNavBar/my%20favorite%20spaces%20mvvm/my_favorite_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';

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
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'lib/assets/images/BackgroundFavfundofav.png',
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
                        offset:
                            const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
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
    );
  }
}

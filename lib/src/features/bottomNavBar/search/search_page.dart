import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/search/search_page_vm.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import '../bottomNavBarPage.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  List<String> searchHistory = [];
  SearchViewModel searchViewModel = SearchViewModel();
  @override
  void initState() {
    searchViewModel.init();

    _controller.addListener(_onTextChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  //x - limpar filtered
  //onsubmit - shwing = true

  @override
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;
    return SafeArea(
      child: AnimatedBuilder(
          animation: searchViewModel,
          builder: (context, child) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      from: y * 0.3,
                      child: Row(
                        children: [
                          _buildSearchBox(x, y),
                          _buildCancelButton(),
                          SizedBox(
                            width: x * 0.03,
                          ),
                        ],
                      ),
                    ),
                    searchViewModel.getIsShowingBool() == true
                        // ? Expanded(
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Padding(
                        //           padding: EdgeInsets.only(top: y * 0.02),
                        //           child: const Text(
                        //             'Buscas recentes',
                        //             style:
                        //                 TextStyle(fontWeight: FontWeight.bold),
                        //           ),
                        //         ),
                        //         Expanded(child: _buildSearchHistory())
                        //       ],
                        //     ),
                        //   )
                        ? Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: searchViewModel.getSpaces().length,
                              itemBuilder: (context, index) {
                                log('aaaaaaaaaa');
                                return NewSpaceCard(
                                  hasHeart: true,
                                  space: searchViewModel.getSpaces()[index],
                                  isReview: false,
                                );
                              },
                            ),
                          )
                        : Column(children: [
                            Lottie.asset(
                              'lib/assets/animations/searchAnimation.json',
                              height: y * 0.3,
                            ),
                            const Text(
                              'Busque pelos melhores espaços disponíveis para o seu Festou!',
                              textAlign: TextAlign.center,
                            ),
                          ]),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildSearchBox(double x, double y) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.search, color: Colors.purple[300]),
              const SizedBox(width: 10.0),
              Expanded(
                child: Stack(
                  children: [
                    _controller.text.isEmpty
                        ? RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.blueGrey[500]),
                              children: const <TextSpan>[
                                TextSpan(text: 'Buscar no '),
                                TextSpan(
                                    text: 'Festou',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        : Container(
                            height: 0,
                          ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  searchViewModel.onChangedSearch(value);
                                },
                                controller: _controller,
                                onSubmitted: (value) {
                                  if (value.trim().isNotEmpty) {
                                    searchViewModel.onClick(true);
                                    _addSearchToHistory(value.trim());

                                    // _controller.clear();
                                  }
                                },
                                autofocus: true,
                                decoration: const InputDecoration(
                                  hintText: 'Buscar no Festou',
                                  hintStyle:
                                      TextStyle(color: Colors.transparent),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                ),
                                style: TextStyle(
                                    color: Colors.blueGrey[900], fontSize: 12),
                                cursorColor: Colors.blueGrey[900],
                              ),
                            ),
                            Visibility(
                              visible: _controller.text.isNotEmpty,
                              child: InkWell(
                                onTap: () {
                                  _controller.clear();
                                  searchViewModel.onClick(false);
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.blueGrey[900],
                                  size: 14,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const BottomNavBarPage(),
      )),
      child: Text(
        'Cancelar',
        style: TextStyle(
          color: Colors.purple[300],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: searchHistory.length,
      itemBuilder: (context, index) {
        final item = searchHistory[index];
        return ListTile(
          title: Text(
            item,
            style: const TextStyle(fontSize: 12),
          ),
          trailing: IconButton(
            alignment: Alignment.centerRight,
            icon: const Icon(
              Icons.clear,
              size: 15,
            ),
            onPressed: () {
              setState(() {
                searchHistory.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }

  void _addSearchToHistory(String search) {
    setState(() {
      // Remove a pesquisa se ela já existir (para evitar duplicatas)
      if (searchHistory.contains(search)) {
        searchHistory.remove(search);
      }

      // Adiciona a pesquisa ao início da lista
      searchHistory.insert(0, search);
    });
  }
}

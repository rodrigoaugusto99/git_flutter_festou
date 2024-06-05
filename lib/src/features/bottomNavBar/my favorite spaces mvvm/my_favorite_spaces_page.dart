import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/my%20favorite%20spaces%20mvvm/my_favorite_spaces_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/my%20favorite%20spaces%20mvvm/my_favorite_spaces_vm.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/my_sliver_list_to_card_info.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';

class MyFavoriteSpacePage extends StatefulWidget {
  const MyFavoriteSpacePage({super.key});

  @override
  State<MyFavoriteSpacePage> createState() => _MyFavoriteSpacePageState();
}

class _MyFavoriteSpacePageState extends State<MyFavoriteSpacePage> {
  final _controller = TextEditingController();
  List<String> searchHistory = [];
  MyFavoriteSpacesVm viewModel = MyFavoriteSpacesVm();
  @override
  void initState() {
    viewModel.init();

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
      body: Column(
        children: [
          Row(
            children: [
              Icon(Icons.search, color: Colors.purple[300]),
              const SizedBox(width: 10.0),
              Stack(
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
                                viewModel.onChangedSearch(value);
                              },
                              controller: _controller,
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Buscar no Festou',
                                hintStyle: TextStyle(color: Colors.transparent),
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
                                viewModel.onClick(false);
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
            ],
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NewCardInfo(space: viewModel.getSpaces()[index]),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: NewSpaceCard(
                    hasHeart: true,
                    space: viewModel.getSpaces()[index],
                    isReview: false,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

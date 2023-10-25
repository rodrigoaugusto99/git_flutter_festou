import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../bottomNavBar/bottomNavBarPage.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  List<String> searchHistory = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
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
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: y * 0.04),
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
            searchHistory.isNotEmpty
                ? SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: x * 0.03),
                      padding: EdgeInsets.symmetric(horizontal: x * 0.0, vertical: y * 0.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: y * 0.1, maxHeight: y * 0.905),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: y * 0.02),
                              child: const Text(
                                'Buscas recentes',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(child: _buildSearchHistory())
                          ],
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Spacer(flex: 5),
                        Lottie.asset(
                          'lib/assets/animations/searchAnimation.json',
                          height: y * 0.3,
                        ),
                        const Spacer(flex: 2),
                        const Text(
                          'Busque pelos melhores espaços disponíveis para o seu Festou!',
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(flex: 13),
                      ]),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(double x, double y) {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: x * 0.03, vertical: 0.03),
            padding: EdgeInsets.symmetric(horizontal: x * 0.02, vertical: y * 0.01),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
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
                                  TextSpan(text: 'Festou', style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          : Container(
                              height: 0,
                            ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              onSubmitted: (value) {
                                if (value.trim().isNotEmpty) {
                                  _addSearchToHistory(value.trim());
                                  _controller.clear();
                                }
                              },
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Buscar no Festou',
                                hintStyle: TextStyle(color: Colors.transparent),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              ),
                              style: TextStyle(color: Colors.blueGrey[900], fontSize: 12),
                              cursorColor: Colors.blueGrey[900],
                            ),
                          ),
                          Visibility(
                            visible: _controller.text.isNotEmpty,
                            child: InkWell(
                              onTap: () => _controller.clear(),
                              child: Icon(
                                Icons.clear,
                                color: Colors.blueGrey[900],
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BottomNavBarPage(previousRoute: '/home/search_page'),
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

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/features/bottomNavBar/search/search_page_vm.dart';
import 'package:festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../bottom_navbar_locatario_page.dart';
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

  final PagingController<int, SpaceModel> _pagingController =
      PagingController(firstPageKey: 0);

  static const int _pageSize = 3;

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
    _pagingController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    String searchText = _controller.text.trim();
    if (searchText.isNotEmpty) {
      _pagingController.refresh(); // Recarrega a lista ao digitar
      _fetchPage(0, searchText); // Passa o texto digitado para a busca
    } else {
      setState(() {
        searchViewModel.onChangedSearch(""); // Limpa a busca
        _pagingController.refresh(); // Atualiza para lista vazia
      });
    }
  }

  Future<void> _fetchPage(int pageKey, String query) async {
    try {
      final newItems =
          await searchViewModel.getPaginatedSpaces(pageKey, _pageSize, query);

      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final x = MediaQuery.of(context).size.width;
    final y = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: AnimatedBuilder(
            animation: searchViewModel,
            builder: (context, child) {
              return Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                      SizedBox(
                        height: y * 0.7,
                        child: Center(
                          child: searchViewModel.getSpaces() != null &&
                                  searchViewModel.getSpaces()!.isNotEmpty
                              ? ListView.builder(
                                  padding: const EdgeInsets.all(10),
                                  itemCount:
                                      searchViewModel.getSpaces()!.length,
                                  itemBuilder: (context, index) {
                                    return NewSpaceCard(
                                      hasHeart: true,
                                      space:
                                          searchViewModel.getSpaces()![index],
                                      isReview: false,
                                    );
                                  },
                                )
                              : searchViewModel.getSpaces() != null &&
                                      searchViewModel.getSpaces()!.isEmpty
                                  ? Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 30),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
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
                                              'lib/assets/animations/not_found.json',
                                              width: 200,
                                              height: 200,
                                              repeat: true,
                                            ),
                                            const SizedBox(height: 20),
                                            const Text(
                                              'Nenhum espaço encontrado!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            const Text(
                                              'Tente ajustar sua busca para encontrar os melhores espaços disponíveis.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black45,
                                              ),
                                            ),
                                            const SizedBox(height: 25),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                _controller.clear();
                                                searchViewModel
                                                    .onChangedSearch('');
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              icon: const Icon(Icons.refresh,
                                                  color: Colors.white),
                                              label: const Text(
                                                  'Tentar Novamente'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.deepPurple,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 12),
                                                textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : _buildSearchAnimation(y),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _buildSearchAnimation(double y) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'lib/assets/animations/searchAnimation.json',
            width: 220, // Maior para melhor visualização
            height: y * 0.3,
            repeat: true,
          ),
          const SizedBox(
              height: 24), // Maior espaçamento entre animação e texto
          const Text(
            'Explore os melhores espaços para o seu Festou!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18, // Fonte maior e mais legível
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Tom mais escuro para melhor contraste
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use a barra de busca acima para encontrar espaços perfeitos para o seu evento.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox(double x, double y) {
    Duration fadeInDuration = const Duration(milliseconds: 400);
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: x * 0.03, vertical: y * 0.02),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed('/home/search_page');
                },
                child: FadeInDown(
                  duration: fadeInDuration,
                  from: y * 0.1,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: x * 0.02, vertical: y * 0.01),
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
                                        style: TextStyle(
                                            color: Colors.blueGrey[500]),
                                        children: const <TextSpan>[
                                          TextSpan(text: 'Buscar no '),
                                          TextSpan(
                                              text: 'Festou',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
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
                                            searchViewModel
                                                .onChangedSearch(value);
                                          },
                                          controller: _controller,
                                          autofocus: true,
                                          decoration: const InputDecoration(
                                            hintText: 'Buscar no Festou',
                                            hintStyle: TextStyle(
                                                color: Colors.transparent),
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0, horizontal: 0),
                                          ),
                                          style: TextStyle(
                                              color: Colors.blueGrey[900],
                                              fontSize: 12),
                                          cursorColor: Colors.blueGrey[900],
                                        ),
                                      ),
                                      Visibility(
                                        visible: _controller.text.isNotEmpty,
                                        child: InkWell(
                                          onTap: () {
                                            _controller.clear();
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
                  ),
                ),
              ),
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
      onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const BottomNavBarLocatarioPage(),
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
}

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
  static const _bg = Color(0xFFFAF7FC);
  static const _ink = Color(0xFF1C1426);
  static const _muted = Color(0xFF8A8096);
  static const _accent = Color(0xFF7C3AED);

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
    final searchText = _controller.text.trim();
    if (searchText.isNotEmpty) {
      _pagingController.refresh();
      _fetchPage(0, searchText);
    } else {
      setState(() {
        searchViewModel.onChangedSearch('');
        _pagingController.refresh();
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

  void _clearSearch() {
    _controller.clear();
    searchViewModel.onChangedSearch('');
    FocusScope.of(context).unfocus();
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const BottomNavBarLocatarioPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AnimatedBuilder(
        animation: searchViewModel,
        builder: (context, child) {
          final spaces = searchViewModel.getSpaces();

          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: _bg,
            body: SafeArea(
              child: Column(
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 320),
                    from: 18,
                    child: _buildHeader(),
                  ),
                  Expanded(
                    child: spaces != null && spaces.isNotEmpty
                        ? ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                            itemCount: spaces.length,
                            itemBuilder: (context, index) {
                              return NewSpaceCard(
                                hasHeart: true,
                                space: spaces[index],
                                isReview: false,
                              );
                            },
                          )
                        : spaces != null && spaces.isEmpty
                            ? _buildEmptyResults()
                            : _buildIdleState(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Buscar',
            style: TextStyle(
              fontFamily: 'RedHatDisplay',
              fontWeight: FontWeight.w900,
              fontSize: 26,
              letterSpacing: -0.5,
              color: _ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Encontre o espaço perfeito para sua festa',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: _muted,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildSearchBox()),
              const SizedBox(width: 10),
              TextButton(
                onPressed: _goHome,
                style: TextButton.styleFrom(
                  foregroundColor: _accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    final hasText = _controller.text.isNotEmpty;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8DFF8)),
        boxShadow: [
          BoxShadow(
            color: _accent.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            color: _accent,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (value) {
                searchViewModel.onChangedSearch(value);
              },
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _ink,
              ),
              cursorColor: _accent,
              decoration: const InputDecoration(
                hintText: 'Buscar no Festou',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: _muted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (hasText)
            InkWell(
              onTap: _clearSearch,
              borderRadius: BorderRadius.circular(99),
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EBFF),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: _accent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIdleState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 12, 32, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'lib/assets/animations/searchAnimation.json',
              width: 200,
              height: 200,
              repeat: true,
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore os melhores espaços',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'RedHatDisplay',
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.3,
                color: _ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Digite na barra acima para encontrar o lugar ideal para o seu evento.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.45,
                color: _muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE8DFF8)),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'lib/assets/animations/not_found.json',
                width: 170,
                height: 170,
                repeat: true,
              ),
              const SizedBox(height: 8),
              const Text(
                'Nenhum espaço encontrado',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'RedHatDisplay',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tente outro termo ou limpe a busca para explorar novamente.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.45,
                  color: _muted,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _clearSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Limpar busca',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

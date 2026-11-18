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
  static const _bg = Color(0xFFFAF7FC);
  static const _ink = Color(0xFF1C1426);
  static const _muted = Color(0xFF8A8096);
  static const _accent = Color(0xFF7C3AED);

  final MyFavoriteSpacesVm viewModel = MyFavoriteSpacesVm();

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

  int get _count => viewModel.allSpaces?.length ?? 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: _bg,
        body: Container(
          decoration: const BoxDecoration(
            color: _bg,
            image: DecorationImage(
              image: AssetImage('lib/assets/images/background_favoritos.png'),
              fit: BoxFit.cover,
              opacity: 0.22,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: viewModel.isLoading
                      ? const Center(child: CustomLoadingIndicator())
                      : viewModel.allSpaces == null ||
                              viewModel.allSpaces!.isEmpty
                          ? _buildEmptyState()
                          : _buildFavoritesList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Favoritos',
                  style: TextStyle(
                    fontFamily: 'RedHatDisplay',
                    fontWeight: FontWeight.w900,
                    fontSize: 26,
                    letterSpacing: -0.5,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _count == 0
                      ? 'Seus espaços salvos aparecem aqui'
                      : _count == 1
                          ? '1 espaço salvo'
                          : '$_count espaços salvos',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificacoesPage(locador: false),
                  ),
                );
              },
              child: Ink(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF7F1FF),
                      Color(0xFFEFE4FF),
                    ],
                  ),
                  border: Border.all(color: const Color(0xFFE0D0FF)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6100FF).withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_rounded,
                      color: Color(0xFF6100FF),
                      size: 24,
                    ),
                    Positioned(
                      top: 11,
                      right: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4D6D),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF4D6D).withOpacity(0.45),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    final spaces = viewModel.allSpaces!;

    return RefreshIndicator(
      color: _accent,
      onRefresh: () async {
        await viewModel.init();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
        itemCount: spaces.length,
        itemBuilder: (context, index) {
          final space = spaces[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NewCardInfo(spaceId: space.spaceId),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: NewSpaceCard(
                hasHeart: true,
                space: space,
                isReview: false,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 100),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94),
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
                'lib/assets/animations/heart_break.json',
                width: 140,
                height: 140,
                repeat: false,
              ),
              const SizedBox(height: 8),
              const Text(
                'Nenhum favorito ainda',
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
                'Explore espaços e toque no coração para salvá-los aqui.',
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
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.search_rounded, size: 20),
                  label: const Text(
                    'Explorar espaços',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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

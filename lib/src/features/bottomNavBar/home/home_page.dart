import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/app_bar_home.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/cupons_e_promocoes.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/feed_noticias.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/menu_space_types.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/search_button.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_state.dart';
import 'package:festou/src/features/show%20spaces/all%20space%20mvvm/all_spaces_vm.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/my_last_seen_spaces.dart';
import 'package:festou/src/features/show%20spaces/surrounding%20spaces/surrounding_spaces_page.dart';

class HomePage extends ConsumerStatefulWidget {
  final String? previousRoute;

  const HomePage({this.previousRoute, super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const _bg = Color(0xFFFAF7FC);

  @override
  Widget build(BuildContext context) {
    final allSpaces = ref.watch(allSpacesVmProvider);
    final message = ref.watch(allSpacesVmProvider.notifier).errorMessage;

    Future.delayed(Duration.zero, () {
      if (message.toString() != '') {
        Messages.showError(message, context);
      }
    });

    final fadeInDuration = (widget.previousRoute == '/home/search_page')
        ? const Duration(milliseconds: 400)
        : Duration.zero;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: _bg,
        body: allSpaces.when(
          data: (AllSpaceState data) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                const AppBarHome(),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                const SliverToBoxAdapter(child: MenuSpaceTypes()),
                SliverToBoxAdapter(
                  child: SearchButton(fadeInDuration: fadeInDuration),
                ),
                const SliverToBoxAdapter(
                  child: _HomeSectionHeader(
                    title: 'Feed de notícias',
                    subtitle: 'Novidades dos espaços que você curte',
                  ),
                ),
                const SliverToBoxAdapter(child: FeedNoticias()),
                const SliverToBoxAdapter(child: MyLastSeenSpaces()),
                const SliverToBoxAdapter(
                  child: _HomeSectionHeader(
                    title: 'Cupons e promoções',
                    subtitle: 'Ofertas pra deixar a festa ainda melhor',
                  ),
                ),
                const SliverToBoxAdapter(child: CuponsEPromocoes()),
                const SliverToBoxAdapter(
                  child: _HomeSectionHeader(
                    title: 'Busque no mapa',
                    subtitle: 'Explore espaços perto de você',
                  ),
                ),
                SliverToBoxAdapter(
                  child: _MapCta(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SurroundingSpacesPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 72)),
              ],
            );
          },
          error: (Object error, StackTrace stackTrace) {
            return const Center(child: Icon(Icons.error_outline_rounded));
          },
          loading: () {
            return const Center(child: CustomLoadingIndicator());
          },
        ),
      ),
    );
  }
}

class _HomeSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _HomeSectionHeader({
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'RedHatDisplay',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: Color(0xFF1C1426),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8A8096),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MapCta extends StatefulWidget {
  final VoidCallback onTap;

  const _MapCta({required this.onTap});

  @override
  State<_MapCta> createState() => _MapCtaState();
}

class _MapCtaState extends State<_MapCta> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1,
          duration: const Duration(milliseconds: 120),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF7F1FF),
                  Color(0xFFEDE0FF),
                  Color(0xFFDCC8FF),
                ],
              ),
              border: Border.all(color: const Color(0xFFD6C0FF)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: const Text(
                            'MAPA',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              letterSpacing: 1.1,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Encontre o espaço ideal',
                          style: TextStyle(
                            fontFamily: 'RedHatDisplay',
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            letterSpacing: -0.3,
                            color: Color(0xFF1C1426),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Toque no globo e explore no mapa',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Color(0xFF6B6175),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Row(
                          children: [
                            Text(
                              'Abrir mapa',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: Color(0xFF7C3AED),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: Color(0xFF7C3AED),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'lib/assets/images/imagem_terra.png',
                    width: 112,
                    height: 112,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

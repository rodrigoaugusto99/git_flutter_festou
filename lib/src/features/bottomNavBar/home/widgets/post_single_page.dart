import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:festou/src/models/post_model.dart';
import 'package:festou/src/services/post_service.dart';

class PostSinglePage extends StatefulWidget {
  final PostModel postModel;
  const PostSinglePage({super.key, required this.postModel});

  @override
  State<PostSinglePage> createState() => _PostSinglePageState();
}

class _PostSinglePageState extends State<PostSinglePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  static const _bg = Color(0xFFFFF9F5);
  static const _ink = Color(0xFF1C1426);
  static const _muted = Color(0xFF6B6175);
  static const _accent = Color(0xFF7C3AED);

  @override
  void initState() {
    super.initState();
    if (widget.postModel.id != null) {
      PostService().setPostAsRead(widget.postModel.id!);
    }

    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeIn = CurvedAnimation(parent: _entrance, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic));
    _entrance.forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  List<String> get _galleryImages {
    final images = widget.postModel.imagens;
    if (images.length <= 1) return const [];
    return images.skip(1).toList();
  }

  String get _heroImage {
    if (widget.postModel.coverPhoto.isNotEmpty) {
      return widget.postModel.coverPhoto;
    }
    return widget.postModel.imagens.first;
  }

  String get _formattedDate {
    try {
      return DateFormat("d 'de' MMMM", 'pt_BR')
          .format(widget.postModel.createdAt.toDate());
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: _bg,
      body: Container(
        decoration: const BoxDecoration(
          color: _bg,
          image: DecorationImage(
            image: AssetImage('lib/assets/images/background_confete.png'),
            fit: BoxFit.contain,
            repeat: ImageRepeat.repeat,
            opacity: 0.4,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: topInset + 8)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _CircleIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 14)),

                // Hero
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _HeroImage(url: _heroImage),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_formattedDate.isNotEmpty)
                          Text(
                            _formattedDate.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              letterSpacing: 1.4,
                              color: _accent,
                            ),
                          ),
                        if (_formattedDate.isNotEmpty)
                          const SizedBox(height: 10),
                        Text(
                          widget.postModel.title,
                          style: const TextStyle(
                            fontFamily: 'RedHatDisplay',
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                            height: 1.2,
                            letterSpacing: -0.4,
                            color: _ink,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.postModel.description,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            height: 1.65,
                            letterSpacing: 0.1,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (_galleryImages.isNotEmpty) ...[
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Text(
                            'Mais fotos',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: _ink,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_galleryImages.length}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: _muted.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 14)),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 160,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _galleryImages.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final url = _galleryImages[index];
                          final fullIndex =
                              widget.postModel.imagens.indexOf(url);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PhotoDetailScreen(
                                    photoUrls: widget.postModel.imagens,
                                    initialIndex:
                                        fullIndex < 0 ? index + 1 : fullIndex,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'gallery_$url',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: AspectRatio(
                                  aspectRatio: 0.85,
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 48)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String url;
  const _HeroImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 5 / 4,
          child: Image.network(
            url,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: const Color(0xFF1C1426), size: 22),
        ),
      ),
    );
  }
}

class PhotoDetailScreen extends StatefulWidget {
  final List<String> photoUrls;
  final int initialIndex;

  const PhotoDetailScreen({
    super.key,
    required this.photoUrls,
    required this.initialIndex,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PhotoDetailScreenState createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _previousImage() {
    setState(() {
      currentIndex = currentIndex == 0
          ? widget.photoUrls.length - 1
          : currentIndex - 1;
    });
  }

  void _nextImage() {
    setState(() {
      currentIndex = currentIndex == widget.photoUrls.length - 1
          ? 0
          : currentIndex + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: Center(
                child: Hero(
                  tag: 'gallery_${widget.photoUrls[currentIndex]}',
                  child: Image.network(
                    widget.photoUrls[currentIndex],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.photoUrls.length, (index) {
                final selected = currentIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: selected ? 18 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    color: selected ? const Color(0xff9747FF) : Colors.white38,
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavCircle(icon: Icons.chevron_left, onTap: _previousImage),
                  _NavCircle(icon: Icons.chevron_right, onTap: _nextImage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavCircle({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(icon, size: 32, color: const Color(0xFF1C1426)),
      ),
    );
  }
}

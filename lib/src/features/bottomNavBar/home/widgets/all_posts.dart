import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/post_single_page.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/models/post_model.dart';

class AllPosts extends StatefulWidget {
  const AllPosts({super.key});

  @override
  State<AllPosts> createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  static const _bg = Color(0xFFFFF9F5);
  static const _ink = Color(0xFF1C1426);
  static const _muted = Color(0xFF6B6175);
  static const _accent = Color(0xFF7C3AED);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  List<DocumentSnapshot> posts = [];
  bool loadingPosts = true;
  bool loadingMorePosts = false;
  bool hasMorePosts = true;
  Map<String, DocumentSnapshot?> lastDocuments = {};
  final int postsPerPage = 6;
  User? user;
  DocumentSnapshot? userDoc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _getPosts();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!hasMorePosts || loadingMorePosts || loadingPosts) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 240) {
      _getMorePosts();
    }
  }

  Future<void> _getUser() async {
    user = _auth.currentUser;
    if (user == null) return;

    final userSnapshot = await _firestore
        .collection('users')
        .where('uid', isEqualTo: user!.uid)
        .get();

    if (userSnapshot.docs.isEmpty) return;
    userDoc = userSnapshot.docs.first;
  }

  Future<void> _getPosts() async {
    await _getUser();
    setState(() => loadingPosts = true);

    if (userDoc == null) {
      setState(() {
        posts = [];
        loadingPosts = false;
        hasMorePosts = false;
      });
      return;
    }

    final thirtyDaysAgo =
        DateTime.now().subtract(const Duration(days: 1000));
    final thirtyDaysAgoTimestamp = Timestamp.fromDate(thirtyDaysAgo);

    final spaceFavoritesDynamic = userDoc!['spaces_favorite'];
    final spaceFavorites = List<String>.from(spaceFavoritesDynamic);
    final postDocuments = <DocumentSnapshot>[];

    for (int i = 0; i < spaceFavorites.length; i++) {
      final space = spaceFavorites[i];
      final isLastSpace = i == spaceFavorites.length - 1;

      if (postDocuments.length >= postsPerPage) break;

      if (isLastSpace) {
        final postsAggregate = _firestore
            .collection('posts')
            .doc(space)
            .collection('posts')
            .where('createdAt', isGreaterThanOrEqualTo: thirtyDaysAgoTimestamp)
            .count();

        final aggregateSnapshot = await postsAggregate.get();
        final postCount = aggregateSnapshot.count;

        if (postCount != null && postCount <= postDocuments.length) {
          hasMorePosts = false;
        }
      }

      final postsSnapshot = await _firestore
          .collection('posts')
          .doc(space)
          .collection('posts')
          .where('createdAt', isGreaterThanOrEqualTo: thirtyDaysAgoTimestamp)
          .orderBy('createdAt', descending: true)
          .limit(postsPerPage - postDocuments.length)
          .get();

      postDocuments.addAll(postsSnapshot.docs);

      if (postsSnapshot.docs.isNotEmpty) {
        lastDocuments[space] = postsSnapshot.docs.last;
      }

      if (postDocuments.length >= postsPerPage) break;

      if (isLastSpace && postDocuments.length < postsPerPage) {
        hasMorePosts = false;
      }
    }

    final festouSnapshot = await _firestore
        .collection('posts')
        .doc('festou')
        .collection('posts')
        .limit(1)
        .get();

    postDocuments.addAll(festouSnapshot.docs);

    setState(() {
      posts = postDocuments;
      loadingPosts = false;
      if (postDocuments.length < postsPerPage) {
        hasMorePosts = false;
      }
    });
  }

  Future<void> _getMorePosts() async {
    if (userDoc == null || loadingMorePosts || !hasMorePosts) return;

    setState(() => loadingMorePosts = true);

    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final thirtyDaysAgoTimestamp = Timestamp.fromDate(thirtyDaysAgo);

    final spaceFavoritesDynamic = userDoc!['spaces_favorite'];
    final spaceFavorites = List<String>.from(spaceFavoritesDynamic);
    final postDocuments = <DocumentSnapshot>[];

    for (int i = 0; i < spaceFavorites.length; i++) {
      final space = spaceFavorites[i];
      final isLastSpace = i == spaceFavorites.length - 1;

      if (postDocuments.length >= postsPerPage) break;

      if (isLastSpace) {
        final postsAggregate = _firestore
            .collection('posts')
            .doc(space)
            .collection('posts')
            .where('createdAt', isGreaterThanOrEqualTo: thirtyDaysAgoTimestamp)
            .count();

        final aggregateSnapshot = await postsAggregate.get();
        final postCount = aggregateSnapshot.count;

        if (postCount != null && postCount <= postDocuments.length) {
          hasMorePosts = false;
        }
      }

      final lastDocument = lastDocuments[space];
      Query postsQuery = _firestore
          .collection('posts')
          .doc(space)
          .collection('posts')
          .where('createdAt', isGreaterThanOrEqualTo: thirtyDaysAgoTimestamp)
          .orderBy('createdAt', descending: true);

      if (lastDocument != null) {
        postsQuery = postsQuery.startAfterDocument(lastDocument);
      }

      final postsSnapshot =
          await postsQuery.limit(postsPerPage - postDocuments.length).get();

      postDocuments.addAll(postsSnapshot.docs);

      if (postsSnapshot.docs.isNotEmpty) {
        lastDocuments[space] = postsSnapshot.docs.last;
      }

      if (isLastSpace && postDocuments.length < postsPerPage) {
        hasMorePosts = false;
      }
    }

    setState(() {
      posts.addAll(postDocuments);
      loadingMorePosts = false;
      if (postDocuments.length < postsPerPage) {
        hasMorePosts = false;
      }
    });
  }

  PostModel _toPostModel(DocumentSnapshot doc) {
    final post = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      title: post['titulo'] ?? '',
      createdAt: post['createdAt'] ?? Timestamp.now(),
      description: post['descricao'] ?? '',
      imagens: List<String>.from(post['imagens'] ?? []),
      coverPhoto: post['coverPhoto'] ?? '',
    );
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
            opacity: 0.35,
          ),
        ),
        child: loadingPosts
            ? const Center(child: CustomLoadingIndicator())
            : CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, topInset + 8, 16, 0),
                      child: Row(
                        children: [
                          _CircleIconButton(
                            icon: Icons.arrow_back_rounded,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Feed de notícias',
                                  style: TextStyle(
                                    fontFamily: 'RedHatDisplay',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 24,
                                    letterSpacing: -0.4,
                                    color: _ink,
                                    height: 1.1,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Novidades dos seus espaços favoritos',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: _muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 22)),

                  if (posts.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(),
                    )
                  else ...[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList.separated(
                        itemCount: posts.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final postModel = _toPostModel(posts[index]);
                          return _PostFeedTile(
                            postModel: postModel,
                            index: index,
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Center(
                          child: loadingMorePosts
                              ? const SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: _accent,
                                  ),
                                )
                              : !hasMorePosts
                                  ? Text(
                                      'Você viu tudo por aqui',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: _muted.withOpacity(0.85),
                                      ),
                                    )
                                  : const SizedBox(height: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 42,
            color: Color(0xFF7C3AED),
          ),
          SizedBox(height: 16),
          Text(
            'Nenhuma notícia ainda',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'RedHatDisplay',
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: Color(0xFF1C1426),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Favorite espaços para receber novidades por aqui.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.45,
              color: Color(0xFF6B6175),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostFeedTile extends StatefulWidget {
  final PostModel postModel;
  final int index;

  const _PostFeedTile({
    required this.postModel,
    required this.index,
  });

  @override
  State<_PostFeedTile> createState() => _PostFeedTileState();
}

class _PostFeedTileState extends State<_PostFeedTile>
    with SingleTickerProviderStateMixin {
  static const _ink = Color(0xFF1C1426);
  static const _muted = Color(0xFF6B6175);
  static const _accent = Color(0xFF7C3AED);

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: 40 * (widget.index % 8)), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _formattedDate {
    try {
      return DateFormat("d 'de' MMM", 'pt_BR')
          .format(widget.postModel.createdAt.toDate());
    } catch (_) {
      return '';
    }
  }

  String get _imageUrl {
    if (widget.postModel.coverPhoto.isNotEmpty) {
      return widget.postModel.coverPhoto;
    }
    if (widget.postModel.imagens.isNotEmpty) {
      return widget.postModel.imagens.first;
    }
    return '';
  }

  void _openPost() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (_, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: PostSinglePage(postModel: widget.postModel),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _openPost,
            borderRadius: BorderRadius.circular(22),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white.withOpacity(0.72),
                border: Border.all(color: const Color(0x147C3AED)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1C1426).withOpacity(0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (_imageUrl.isNotEmpty)
                            Image.network(
                              _imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFFEFE4FF),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: _accent,
                                ),
                              ),
                            )
                          else
                            Container(
                              color: const Color(0xFFEFE4FF),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.celebration_outlined,
                                color: _accent,
                                size: 36,
                              ),
                            ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: 72,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.28),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (_formattedDate.isNotEmpty)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.92),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: Text(
                                  _formattedDate,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                    letterSpacing: 0.2,
                                    color: _accent,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.postModel.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'RedHatDisplay',
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            height: 1.25,
                            letterSpacing: -0.2,
                            color: _ink,
                          ),
                        ),
                        if (widget.postModel.description.trim().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.postModel.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 13.5,
                              height: 1.45,
                              color: _muted,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        const Row(
                          children: [
                            Text(
                              'Ler notícia',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: _accent,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: _accent,
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
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: const Color(0xFF1C1426),
            size: 22,
          ),
        ),
      ),
    );
  }
}

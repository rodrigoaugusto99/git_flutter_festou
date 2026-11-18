import 'package:flutter/material.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/all_posts.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/each_post.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/post_single_page.dart';
import 'package:festou/src/models/post_model.dart';
import 'package:festou/src/services/post_service.dart';
import 'package:shimmer/shimmer.dart';

class FeedNoticias extends StatefulWidget {
  const FeedNoticias({super.key});

  @override
  State<FeedNoticias> createState() => _FeedNoticiasState();
}

class _FeedNoticiasState extends State<FeedNoticias> {
  final PostService postService = PostService();
  late Future<_FeedData> _feedFuture;

  @override
  void initState() {
    super.initState();
    _feedFuture = _loadFeed();
  }

  Future<_FeedData> _loadFeed() async {
    final unread = await postService.getPostModelsBySpaceIds() ?? [];
    if (unread.isNotEmpty) {
      return _FeedData(posts: unread, showingSeen: false);
    }

    final seen = await postService.getSeenPosts();
    seen.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _FeedData(posts: seen, showingSeen: true);
  }

  void _openPost(PostModel post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostSinglePage(postModel: post),
      ),
    ).then((_) {
      if (!mounted) return;
      setState(() {
        _feedFuture = _loadFeed();
      });
    });
  }

  void _openAllPosts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AllPosts()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_FeedData>(
      future: _feedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 250,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 6.5),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 221, 221, 221),
                      highlightColor: Colors.white,
                      child: Container(
                        width: 174,
                        height: 110,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data;
        if (data == null || data.posts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 120,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _VerMaisCard(onTap: _openAllPosts, compact: true),
              ),
            ),
          );
        }

        final posts = data.posts;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.showingSeen)
              const Padding(
                padding: EdgeInsets.only(left: 16, bottom: 8),
                child: Text(
                  'Vistos recentemente',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B6175),
                  ),
                ),
              ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 8),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    return _VerMaisCard(onTap: _openAllPosts);
                  }

                  final post = posts[index];
                  return SizedBox(
                    height: 250,
                    width: 174,
                    child: InkWell(
                      onTap: () => _openPost(post),
                      child: EachPost(post: post),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FeedData {
  final List<PostModel> posts;
  final bool showingSeen;

  const _FeedData({
    required this.posts,
    required this.showingSeen,
  });
}

class _VerMaisCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool compact;

  const _VerMaisCard({
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 96 : 244,
      width: compact ? double.infinity : 150,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: compact ? 0 : 8,
            vertical: compact ? 0 : 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF3EBFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDCC8FF)),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xff4300B1),
                size: 22,
              ),
              SizedBox(height: 8),
              Text(
                'Ver mais',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xff4300B1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
  PostService postService = PostService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostModel>?>(
      future: postService.getPostModelsBySpaceIds(),
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
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Não há posts"));
        }

        final posts = snapshot.data!;

        // posts.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                if (index == posts.length - 1 /*&& posts.length >= 10*/) {
                  return Row(
                    children: [
                      SizedBox(
                        height: 244,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return PostSinglePage(
                                      postModel: posts[index]);
                                },
                              ),
                            );
                          },
                          child: EachPost(
                            post: post,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 250,
                        width: 170,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const AllPosts();
                                },
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ver todos',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5, top: 2),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Color(0xff4300B1),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }
                return SizedBox(
                  height: 250,
                  width: 174,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PostSinglePage(postModel: posts[index]);
                          },
                        ),
                      );
                    },
                    child: EachPost(
                      post: post,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

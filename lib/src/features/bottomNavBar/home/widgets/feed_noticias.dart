import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/each_post.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/home/widgets/post_single_page.dart';
import 'package:git_flutter_festou/src/models/post_model.dart';
import 'package:git_flutter_festou/src/services/post_service.dart';
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
    double y = MediaQuery.of(context).size.height;
    double x = MediaQuery.of(context).size.width;
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
                        height: 250,
                        width: 182.0,
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
          return const Center(child: Text("No spaces viewed recently."));
        }

        final posts = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                log(index.toString(), name: 'index');
                log(posts.length.toString(), name: 'posts.lentgth');
                if (index == posts.length - 1 /*&& posts.length >= 10*/) {
                  log('entroui');
                  return Row(
                    children: [
                      InkWell(
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
                      const SizedBox(
                        height: 244,
                        width: 181,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ver todos',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Color(0xff4300B1),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }
                return InkWell(
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}

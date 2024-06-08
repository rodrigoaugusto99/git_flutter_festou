import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/post_model.dart';
import 'package:git_flutter_festou/src/services/post_service.dart';

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
              height: y * 0.21,
              child: const Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No spaces viewed recently."));
        }

        final posts = snapshot.data!;

        return SizedBox(
          height: y * 0.3,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  width: x * 0.40,
                  child: Column(
                    children: [
                      Text(post.title),
                      Text(post.description),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

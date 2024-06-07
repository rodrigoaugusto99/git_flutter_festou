import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/post_model.dart';

class FeedNoticias extends StatefulWidget {
  const FeedNoticias({super.key});

  @override
  State<FeedNoticias> createState() => _FeedNoticiasState();
}

class _FeedNoticiasState extends State<FeedNoticias> {
  List<PostModel> posts = [
    PostModel(
        title: 'post 1',
        description: 'description 1',
        imagens: [],
        coverPhoto: ''),
    PostModel(
        title: 'post 2',
        description: 'description 2',
        imagens: [],
        coverPhoto: ''),
    PostModel(
        title: 'post 3',
        description: 'description 3',
        imagens: [],
        coverPhoto: ''),
  ];
  @override
  Widget build(BuildContext context) {
    double y = MediaQuery.of(context).size.height;
    double x = MediaQuery.of(context).size.width;
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
  }
}

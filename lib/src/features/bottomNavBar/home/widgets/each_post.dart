import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Festou/src/models/post_model.dart';
import 'package:shimmer/shimmer.dart';

class EachPost extends StatefulWidget {
  final PostModel post;
  const EachPost({super.key, required this.post});

  @override
  State<EachPost> createState() => _EachPostState();
}

class _EachPostState extends State<EachPost> {
  Future<void> _loadImage(String url) async {
    final ImageStream stream =
        NetworkImage(url).resolve(ImageConfiguration.empty);
    final Completer<void> completer = Completer();
    final ImageStreamListener listener = ImageStreamListener((_, __) {
      completer.complete();
    }, onError: (Object exception, StackTrace? stackTrace) {
      completer.completeError(exception);
    });
    stream.addListener(listener);
    await completer.future;
    stream.removeListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<void>(
        future: _loadImage(widget.post.imagens[0]),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 221, 221, 221),
                    highlightColor: Colors.white,
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 221, 221, 221),
                    highlightColor: Colors.white,
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 221, 221, 221),
                    highlightColor: Colors.white,
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading image'));
          } else {
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                //color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 170,
              height: 110,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    //clipBehavior: Clip.none,
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.post.coverPhoto,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 120,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                            bottom: Radius.circular(24)),
                        color: const Color(0xff4300B1).withOpacity(0.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                Text(
                                  widget.post.title,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 7),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.post.description,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

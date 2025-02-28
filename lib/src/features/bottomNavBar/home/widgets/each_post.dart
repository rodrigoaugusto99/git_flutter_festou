import 'dart:async';
import 'package:flutter/material.dart';
import 'package:festou/src/models/post_model.dart';
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
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 221, 221, 221),
                highlightColor: Colors.white,
                child: Container(
                  width: 170,
                  height: 110,
                  color: Colors.red,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar imagem'));
          } else {
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(10), // Mantendo arredondamento
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Sombra suave
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              width: 170,
              height: 110,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.post.coverPhoto,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradiente para melhorar a legibilidade do texto (ocupa toda a largura)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(
                              10), // Mantém o mesmo arredondamento
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.4),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título do post
                          Center(
                            child: Text(
                              widget.post.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Descrição do post com 3 linhas e ellipses
                          Text(
                            widget.post.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                            maxLines: 3, // Permite até 3 linhas antes de cortar
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

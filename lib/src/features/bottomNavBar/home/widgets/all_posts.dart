import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/features/bottomNavBar/home/widgets/post_single_page.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:festou/src/models/post_model.dart';

class AllPosts extends StatefulWidget {
  const AllPosts({super.key});

  @override
  State<AllPosts> createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<DocumentSnapshot> posts = [];
  bool loadingPosts = true;
  bool loadingMorePosts = false;
  bool hasMorePosts = true;
  Map<String, DocumentSnapshot?> lastDocuments = {};
  final int postsPerPage = 2;
  User? user;
  DocumentSnapshot? userDoc;
  bool hideVerMaisButton = false;

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  Future<void> _getUser() async {
    user = _auth.currentUser;
    if (user == null) {
      // Handle the case where the user is not logged in
      return;
    }

    QuerySnapshot userSnapshot = await _firestore
        .collection('users')
        .where('uid', isEqualTo: user!.uid)
        .get();

    if (userSnapshot.docs.isEmpty) {
      // Handle the case where the user document is not found
      return;
    }

    userDoc = userSnapshot.docs.first;
  }

  Future<void> _getPosts() async {
    await _getUser();
    setState(() {
      loadingPosts = true;
    });

    if (userDoc == null) return;
    DateTime thirtyDaysAgo =
        DateTime.now().subtract(const Duration(days: 1000));
    Timestamp thirtyDaysAgoTimestamp = Timestamp.fromDate(thirtyDaysAgo);

    List<dynamic> spaceFavoritesDynamic = userDoc!['spaces_favorite'];
    List<String> spaceFavorites = List<String>.from(spaceFavoritesDynamic);
    List<DocumentSnapshot> postDocuments = [];

    for (int i = 0; i < spaceFavorites.length; i++) {
      String space = spaceFavorites[i];
      bool isLastSpace = i == spaceFavorites.length - 1;

      if (postDocuments.length >= postsPerPage) break;

      if (isLastSpace) {
        AggregateQuery postsAggregate = _firestore
            .collection('posts')
            .doc(space)
            .collection('posts')
            .where('createdAt', isGreaterThanOrEqualTo: thirtyDaysAgoTimestamp)
            .count();

        AggregateQuerySnapshot aggregateSnapshot = await postsAggregate.get();
        int? postCount = aggregateSnapshot.count;

        // If the count of posts is less than the total posts per page, set hasMorePosts to false
        if (postCount! <= postDocuments.length) {
          setState(() {
            hasMorePosts = false;
          });
        }
      }

      QuerySnapshot postsSnapshot = await _firestore
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

      // If it's the last space and there are no more posts to load, update hasMorePosts
      if (isLastSpace && postDocuments.length < postsPerPage) {
        setState(() {
          hasMorePosts = false;
        });
      }
    }

    // Adiciona o post da coleção "festou"
    QuerySnapshot festouSnapshot = await _firestore
        .collection('posts')
        .doc('festou')
        .collection('posts')
        .limit(1)
        .get();

    postDocuments.addAll(festouSnapshot.docs);

    setState(() {
      posts = postDocuments;
      loadingPosts = false;
      // Update hasMorePosts if the number of posts loaded is less than postsPerPage
      if (postDocuments.length < postsPerPage) {
        hasMorePosts = false;
      }
    });
  }

  Future<void> _getMorePosts() async {
    if (userDoc == null) return;
    if (loadingMorePosts) return;

    setState(() {
      loadingMorePosts = true;
    });
    hideVerMaisButton = true;

    DateTime thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    Timestamp thirtyDaysAgoTimestamp = Timestamp.fromDate(thirtyDaysAgo);

    List<dynamic> spaceFavoritesDynamic = userDoc!['spaces_favorite'];
    List<String> spaceFavorites = List<String>.from(spaceFavoritesDynamic);
    List<DocumentSnapshot> postDocuments = [];

    for (int i = 0; i < spaceFavorites.length; i++) {
      String space = spaceFavorites[i];
      bool isLastSpace = i == spaceFavorites.length - 1;

      if (postDocuments.length >= postsPerPage) break;

      if (isLastSpace) {
        AggregateQuery postsAggregate = _firestore
            .collection('posts')
            .doc(space)
            .collection('posts')
            .where('createdAt', isGreaterThanOrEqualTo: thirtyDaysAgoTimestamp)
            .count();

        AggregateQuerySnapshot aggregateSnapshot = await postsAggregate.get();
        int? postCount = aggregateSnapshot.count;

        // If the count of posts is less than the total posts per page, set hasMorePosts to false
        if (postCount! <= postDocuments.length) {
          setState(() {
            hasMorePosts = false;
          });
        }
      }

      DocumentSnapshot? lastDocument = lastDocuments[space];
      Query postsQuery = _firestore
          .collection('posts')
          .doc(space)
          .collection('posts')
          .where('createdAt', isGreaterThanOrEqualTo: thirtyDaysAgoTimestamp)
          .orderBy('createdAt', descending: true);

      if (lastDocument != null) {
        postsQuery = postsQuery.startAfterDocument(lastDocument);
      }

      QuerySnapshot postsSnapshot = await postsQuery.get();

      postDocuments.addAll(postsSnapshot.docs);

      if (postsSnapshot.docs.isNotEmpty) {
        lastDocuments[space] = postsSnapshot.docs.last;
      }

      if (isLastSpace && postDocuments.length < postsPerPage) {
        setState(() {
          hasMorePosts = false;
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfff8f8f8), // Cor roxa no topo
              Color(0xff4300B1), // Fundo claro abaixo
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50), // Espaço para a AppBar

            // AppBar customizada
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botão de voltar estilizado
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),

                  // Título centralizado
                  const Text(
                    'Posts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Deixa o título mais visível
                    ),
                  ),

                  // Espaço para alinhar corretamente
                  const SizedBox(width: 40),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Lista de posts
            Expanded(
              child: loadingPosts
                  ? const Center(child: CustomLoadingIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1 / 1.28,
                        ),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> post =
                              posts[index].data() as Map<String, dynamic>;

                          final postModel = PostModel(
                            title: post['titulo'],
                            createdAt: post['createdAt'],
                            description: post['descricao'],
                            imagens: List<String>.from(post['imagens'] ?? []),
                            coverPhoto: post['coverPhoto'],
                          );

                          return AllPostsWidget(postModel: postModel);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllPostsWidget extends StatelessWidget {
  final PostModel postModel;
  const AllPostsWidget({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PostSinglePage(postModel: postModel);
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), // Bordas arredondadas
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Sombra suave
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16), // Mantém bordas arredondadas
          child: Stack(
            children: [
              // Imagem de fundo do post
              Positioned.fill(
                child: Image.network(
                  postModel.coverPhoto,
                  fit: BoxFit.cover,
                ),
              ),

              // Gradiente para melhorar a legibilidade do texto
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Texto do post
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título do post
                      Center(
                        child: Text(
                          postModel.title,
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

                      // Descrição do post
                      Text(
                        postModel.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

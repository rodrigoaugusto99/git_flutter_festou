import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';
import 'package:git_flutter_festou/src/models/post_model.dart';
import 'package:loading_indicator/loading_indicator.dart';

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
  final int postsPerPage = 10;
  User? user;
  DocumentSnapshot? userDoc;

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

    setState(() {
      posts = postDocuments;
      loadingPosts = false;
      // Update hasMorePosts if the number of posts loaded is less than postsPerPage
      if (postDocuments.length < postsPerPage) {
        hasMorePosts = false;
      }
    });

    // Adding final log to check the state of h
  }

  Future<void> _getMorePosts() async {
    if (userDoc == null) return;
    if (loadingMorePosts) return;

    setState(() {
      loadingMorePosts = true;
    });

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

      QuerySnapshot postsSnapshot =
          await postsQuery.limit(postsPerPage - postDocuments.length).get();

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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Container(
            decoration: BoxDecoration(
              //color: Colors.white.withOpacity(0.7),
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Posts',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: hasMorePosts ? posts.length + 1 : posts.length,
        itemBuilder: (context, index) {
          if (index == posts.length) {
            return hasMorePosts
                ? ElevatedButton(
                    onPressed: _getMorePosts,
                    child: loadingMorePosts
                        ? const CustomLoadingIndicator()
                        : const Text('Load More'),
                  )
                : const SizedBox.shrink();
          }

          Map<String, dynamic> post =
              posts[index].data() as Map<String, dynamic>;

          final postModel = PostModel(
            title: post['titulo'],
            description: post['descricao'],
            imagens: List<String>.from(post['imagens'] ?? []),
            coverPhoto: post['coverPhoto'],
          );

          return AllPostsWidget(
            postModel: postModel,
          );
        },
      ),
    );
  }
}

class AllPostsWidget extends StatelessWidget {
  final PostModel postModel;
  const AllPostsWidget({
    super.key,
    required this.postModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: 174,
      height: 110,
      child: Stack(
        children: [
          ClipRRect(
            //clipBehavior: Clip.none,
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              height: 250,
              postModel.coverPhoto,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
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
                          postModel.title,
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
                      postModel.description,
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
}

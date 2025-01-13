import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/loading_indicator.dart';

class AllPosts extends StatefulWidget {
  const AllPosts({super.key});

  @override
  State<AllPosts> createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _spaces = [];
  bool _loadingSpaces = true;
  bool _loadingMoreSpaces = false;
  DocumentSnapshot? _lastDocument;
  final int _spacesPerPage = 3;
  bool _hasMoreSpaces = true;

  @override
  void initState() {
    super.initState();
    _getSpaces();
  }

  _getSpaces() async {
    setState(() {
      _loadingSpaces = true;
    });

    QuerySnapshot querySnapshot =
        await _firestore.collection('posts').limit(_spacesPerPage).get();

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    }

    setState(() {
      _spaces = querySnapshot.docs;
      _loadingSpaces = false;
      _hasMoreSpaces = querySnapshot.docs.length == _spacesPerPage;
    });
  }

  _getMoreSpaces() async {
    if (_loadingMoreSpaces) return;

    setState(() {
      _loadingMoreSpaces = true;
    });

    QuerySnapshot querySnapshot = await _firestore
        .collection('spaces')
        .startAfterDocument(_lastDocument!)
        .limit(_spacesPerPage)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    }

    setState(() {
      _spaces.addAll(querySnapshot.docs);
      _loadingMoreSpaces = false;
      _hasMoreSpaces = querySnapshot.docs.length == _spacesPerPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spaces'),
      ),
      body: ListView.builder(
        itemCount: _spaces.length + 1,
        itemBuilder: (context, index) {
          if (index == _spaces.length) {
            return _hasMoreSpaces
                ? ElevatedButton(
                    onPressed: _getMoreSpaces,
                    child: _loadingMoreSpaces
                        ? const CustomLoadingIndicator()
                        : const Text('Carregar mais'),
                  )
                : const SizedBox.shrink();
          }

          Map<String, dynamic> space =
              _spaces[index].data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  space['titulo'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                    style: const TextStyle(
                      color: Color(0xff5E5E5E),
                    ),
                    '(${space['num_comments']})'),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseTeste3 extends StatefulWidget {
  const FirebaseTeste3({super.key});

  @override
  State<FirebaseTeste3> createState() => _FirebaseTeste3State();
}

class _FirebaseTeste3State extends State<FirebaseTeste3> {
  final user = FirebaseAuth.instance.currentUser!;

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: [
          Text('Logged in as: ${user.email}'),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(), // Exibe um indicador de carregamento circular
                  );
                }

                return ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return ListTile(
                          title: Text(data['name']),
                          subtitle: Text(data['email']),
                        );
                      })
                      .toList()
                      .cast(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

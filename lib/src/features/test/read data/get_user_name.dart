import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/* chamar esse widget quando tivermos o document id */
class GetUserName extends StatelessWidget {
  final String documentId;

  const GetUserName({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    //get the collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          /*esse mapa são os dados do usuario cadastrados
          na hora do registro, onde será usado o 
          FirebaseFirestore.instance.collection('users').add({objeto do usuario}) */
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("Name: ${data['name']}\nCEP: ${data['cep']}");
        }
        return Container();
      },
    );
  }
}

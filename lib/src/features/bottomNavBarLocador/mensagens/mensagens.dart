import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/chat_page.dart';

import '../../loading_indicator.dart';

class Mensagens extends StatefulWidget {
  const Mensagens({Key? key}) : super(key: key);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<QuerySnapshot> chatsFuture;

  @override
  void initState() {
    super.initState();
    // Inicializa chatsFuture no initState
    chatsFuture = getChatRooms();
  }

  Future<QuerySnapshot> getChatRooms() async {
    final currentUserID = _auth.currentUser!.uid;
    return await _firestore
        .collection('chat_rooms')
        .where('chatRoomIDs', arrayContains: currentUserID)
        .get();
  }

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  Future<DocumentSnapshot> getUserDocumentById(String userId) async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: userId).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0]; // Retorna o primeiro documento encontrado.
    }

    // Trate o caso em que nenhum usuário foi encontrado.
    throw Exception("Usuário não encontrado");
  }

  Future<String> getNameById(String id) async {
    final userDocument = await getUserDocumentById(id);

    final userData = userDocument.data() as Map<String, dynamic>;

    return userData['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2), // changes position of shadow
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
          'Mensagens',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: chatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoadingIndicator();
          } else if (snapshot.hasError) {
            return const Text('Erro ao carregar os dados');
          } else {
            // Atualiza o estado e renderiza a lista
            return buildChatRoomList(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget buildChatRoomList(QuerySnapshot chats) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: chats.docs.length,
      itemBuilder: (context, index) {
        final chatRoom = chats.docs[index].data() as Map<String, dynamic>;
        final chatRoomIDs = chatRoom['chatRoomIDs'] as List<dynamic>;
        final currentUserID = _auth.currentUser!.uid;

        bool idsIguais =
            chatRoomIDs.every((element) => element == chatRoomIDs[0]);

        // Encontrar o ID do outro usuário
        Future<String>? otherNameFuture;
        String name = '';

        String otherUserID = '';

        if (!idsIguais) {
          otherUserID = chatRoomIDs.firstWhere((id) => id != currentUserID);
          otherNameFuture = getNameById(otherUserID);
        } else {
          // Usuário atual
          name = 'Você';
          otherUserID = currentUserID;
        }

        // Use FutureBuilder para construir o ListTile quando o nome estiver pronto
        return FutureBuilder<String>(
          future: otherNameFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              name = snapshot.data ??
                  ''; // Use o nome do snapshot se estiver disponível
            }

            // Agora, você pode usar o 'name' para exibir na lista
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      //receiverName: widget.space.locadorName,
                      receiverID: otherUserID,
                    ),
                  ),
                );
              },
              child: Container(
                  alignment: Alignment.center,
                  height: 95,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.purple,
                        radius: 35,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'horario',
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'blaablbalblablablablablablblabladsadasdsdadadadasdaddsas',
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.purple,
                                  radius: 10,
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            );
          },
        );
      },
    );
  }
}

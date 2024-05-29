import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/chat_page.dart';

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
        title: const Text('Mensagens'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: chatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.purple[200],
                ),
                child: ListTile(
                  title: Text(name),
                  // Adicione mais detalhes ou ações conforme necessário
                ),
              ),
            );
          },
        );
      },
    );
  }
}

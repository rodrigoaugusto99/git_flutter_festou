import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/services/chat_services.dart';

class ChatPage extends StatelessWidget {
  //final String receiverName;
  final String receiverID;
  ChatPage({
    super.key,
    // required this.receiverName,
    required this.receiverID,
  });

  final messageEC = TextEditingController();

  final ChatServices _chatServices = ChatServices();
  final user = FirebaseAuth.instance.currentUser!;

  void sendMessage() async {
    if (messageEC.text.isNotEmpty) {
      await _chatServices.sendMessage(receiverID, messageEC.text);

      messageEC.clear();
    }
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

    return userData['nome'];
  }

  @override
  Widget build(BuildContext context) {
    String senderID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: getNameById(receiverID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              /*se receiver veio com uma string vazia, é pq
              nao tem um "outro" id, então quer dizer que são iguais,
              então quer dizer que essa é a conversa comigo mesmo*/
              return Text(snapshot.data ?? 'Você');
            } else {
              return const Text(
                  'Carregando...'); // ou outro indicador de carregamento
            }
          },
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _chatServices.getMessages(senderID, receiverID),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Error");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
              return Expanded(
                child: ListView(
                    children: snapshot.data!.docs
                        .map((e) => _buildMessageItemm(e))
                        .toList()),
              );
            },
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItemm(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['uid'] == user.uid;

    var aligmnent =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(alignment: aligmnent, child: Text(data['message']));
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageEC,
            decoration: const InputDecoration(
              hintText: 'type a message',
            ),
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.arrow_upward),
        ),
      ],
    );
  }
}

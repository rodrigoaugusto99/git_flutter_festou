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

  @override
  Widget build(BuildContext context) {
    String senderID = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        //title: Text(receiverName),
        title: const Text('colocar nome de acordo do outro de acordo com id'),
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

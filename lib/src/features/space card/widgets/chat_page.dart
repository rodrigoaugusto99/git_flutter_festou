import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para copiar ao clipboard
import 'package:git_flutter_festou/src/features/space%20card/widgets/chat_bubble.dart';
import 'package:git_flutter_festou/src/services/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String receiverID;
  ChatPage({
    super.key,
    required this.receiverID,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageEC = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  Set<String> selectedMessageIds = {};
  final CollectionReference chatRoomsCollection =
      FirebaseFirestore.instance.collection('chat_rooms');
  bool onLongPressSelected = false;
  int selectionCounter = 0;

  void sendMessage() async {
    if (messageEC.text.isNotEmpty) {
      await _chatServices.sendMessage(widget.receiverID, messageEC.text);
      messageEC.clear();
    }
  }

  void selectMessage(String messageId) {
    setState(() {
      if (selectedMessageIds.contains(messageId)) {
        selectionCounter--;
        selectedMessageIds.remove(messageId);
        if (selectionCounter == 0) {
          deselectAllMessages();
        }
      } else {
        selectionCounter++;
        selectedMessageIds.add(messageId);
      }
    });
  }

  void deselectAllMessages() {
    setState(() {
      selectedMessageIds.clear();
      onLongPressSelected = false;
      selectionCounter = 0;
    });
  }

  void copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    deselectAllMessages();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mensagem copiada')),
    );
  }

  void deleteMessage(String messageId) async {
    String senderID = FirebaseAuth.instance.currentUser!.uid;
    String chatRoomId = widget.receiverID + "_" + senderID;

    try {
      await chatRoomsCollection
          .doc(
              chatRoomId) // Usando a combinação de senderID e receiverID como ID do documento da sala de chat
          .collection('messages')
          .doc(messageId)
          .delete();
      deselectAllMessages();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mensagem excluída')),
      );
    } catch (e) {
      deselectAllMessages();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir mensagem: $e')),
      );
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
    return userData['name'];
  }

  Future<String> getAvatarById(String id) async {
    final userDocument = await getUserDocumentById(id);
    final userData = userDocument.data() as Map<String, dynamic>;
    return userData['avatar_url'];
  }

  @override
  Widget build(BuildContext context) {
    String senderID = FirebaseAuth.instance.currentUser!.uid;
    String chatRoomId = senderID + "_" + widget.receiverID;

    return Scaffold(
      appBar: AppBar(
        leading: selectedMessageIds.isEmpty
            ? FutureBuilder<String>(
                future: getAvatarById(widget.receiverID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CircleAvatar(
                      child: snapshot.data != ''
                          ? Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: 60, // ajuste conforme necessário
                              height: 60, // ajuste conforme necessário
                            )
                          : const Icon(
                              Icons.person,
                              size: 60,
                            ),
                    );
                  } else {
                    return const Text(
                        'Carregando...'); // ou outro indicador de carregamento
                  }
                },
              )
            : IconButton(
                icon: Icon(Icons.close),
                onPressed: deselectAllMessages,
              ),
        title: selectedMessageIds.isEmpty
            ? FutureBuilder<String>(
                future: getNameById(widget.receiverID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data ?? 'Você');
                  } else {
                    return const Text(
                        'Carregando...'); // ou outro indicador de carregamento
                  }
                },
              )
            : Text("Selecionado"),
        actions: selectedMessageIds.isEmpty
            ? []
            : [
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    // Obter a mensagem específica para copiar
                    for (var messageId in selectedMessageIds) {
                      DocumentReference docRef = chatRoomsCollection
                          .doc(chatRoomId)
                          .collection('messages')
                          .doc(messageId);
                      docRef.get().then((DocumentSnapshot doc) {
                        String message =
                            (doc.data() as Map<String, dynamic>)['message'];
                        copyMessage(message);
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    for (var messageId in selectedMessageIds) {
                      deleteMessage(messageId);
                    }
                  },
                ),
              ],
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _chatServices.getMessages(senderID, widget.receiverID),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Error");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
              return Expanded(
                child: ListView(
                  reverse: true,
                  children: snapshot.data!.docs
                      .map<Widget>((e) => _buildMessageItem(e))
                      .toList(),
                ),
              );
            },
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final user = FirebaseAuth.instance.currentUser!;
    bool isCurrentUser = data['senderID'] == user.uid;
    String messageId = doc.id;

    bool isSelected = selectedMessageIds.contains(messageId);

    return GestureDetector(
      onLongPress: () {
        if (!onLongPressSelected) {
          selectMessage(messageId);
          onLongPressSelected = true;
        }
      },
      onTap: () {
        if (onLongPressSelected) {
          selectMessage(messageId);
        }
      },
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ExpandableMessage(
            message: data['message'],
            isCurrentUser: isCurrentUser,
            isSelected: isSelected,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.grey,
              ),
              child: TextField(
                controller: messageEC,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: 'Mensagem',
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.purple[400]),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandableMessage extends StatefulWidget {
  final String message;
  final bool isCurrentUser;
  final bool isSelected;

  ExpandableMessage({
    required this.message,
    required this.isCurrentUser,
    required this.isSelected,
  });

  @override
  _ExpandableMessageState createState() => _ExpandableMessageState();
}

class _ExpandableMessageState extends State<ExpandableMessage> {
  int maxLength = 200;

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      message: _buildMessage(widget.message),
      isCurrentUser: widget.isCurrentUser,
      isSelected: widget.isSelected,
    );
  }

  Widget _buildMessage(String message) {
    if (message.length > maxLength) {
      return RichText(
        text: TextSpan(
          text: message.substring(0, maxLength),
          style: TextStyle(color: Colors.black), // Estilo da mensagem
          children: [
            TextSpan(
              text: "...ver mais",
              style: TextStyle(color: Colors.blue), // Estilo do link "ver mais"
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    maxLength += 500;
                  });
                },
            ),
          ],
        ),
      );
    } else {
      return Text(message);
    }
  }
}

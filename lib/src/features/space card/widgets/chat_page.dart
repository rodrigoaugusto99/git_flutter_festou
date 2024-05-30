import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/chat_bubble.dart';
import 'package:git_flutter_festou/src/services/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String receiverID;
  const ChatPage({
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
  bool onLongPressSelection = false;
  int counterSelection = 0;
  String userID = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _markMessagesAsSeen() async {
    await _chatServices.markMessagesAsSeen(widget.receiverID);
  }

  void sendMessage() async {
    if (messageEC.text.isNotEmpty) {
      await _chatServices.sendMessage(widget.receiverID, messageEC.text);
      messageEC.clear();
    }
  }

  void selectMessage(String messageId) {
    setState(() {
      if (selectedMessageIds.contains(messageId)) {
        selectedMessageIds.remove(messageId);
        counterSelection--;
        if (counterSelection == 0) {
          onLongPressSelection = false;
        }
      } else {
        selectedMessageIds.add(messageId);
        counterSelection++;
      }
    });
  }

  void deselectAllMessages() {
    setState(() {
      selectedMessageIds.clear();
      onLongPressSelection = false;
      counterSelection = 0;
    });
  }

  void copyMessage(String message) {
    Clipboard.setData(ClipboardData(text: message));
    deselectAllMessages();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mensagem copiada')),
    );
  }

  Future<void> deleteMessage(
      Set<String> messagesIds, int messagesToDelete) async {
    final chatRoomId = getChatRoomId();
    final messageCollection =
        chatRoomsCollection.doc(chatRoomId).collection('messages');
    final context = this.context;
    final remainingMessages = await messageCollection.get();
    final totalRemainingMessages = remainingMessages.size - messagesToDelete;

    try {
      bool? confirmDeletionMessage = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: messagesToDelete > 1
                ? const Text('Tem certeza que deseja apagar as mensagens?')
                : const Text('Tem certeza que deseja apagar a mensagem?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  deselectAllMessages();
                },
              ),
              TextButton(
                child: const Text('Confirmar'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (confirmDeletionMessage == true) {
        for (var messageId in messagesIds) {
          await messageCollection.doc(messageId).delete();
        }

        if (totalRemainingMessages == 0) {
          bool? confirmDeletionChat = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirmar Exclusão'),
                content: const Text(
                    'Não há mais mensagens no chat, deseja apagar a conversa?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      deselectAllMessages();
                    },
                  ),
                  TextButton(
                    child: const Text('Confirmar'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );

          if (confirmDeletionChat == true) {
            await chatRoomsCollection.doc(chatRoomId).delete();

            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/home2',
                (Route<dynamic> route) => false,
                arguments: 2,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Conversa apagada')),
              );
            }
          }
        } else {
          deselectAllMessages();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mensagem excluída')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir mensagem: $e')),
      );
    }
  }

  String getChatRoomId() {
    List<String> ids = [userID, widget.receiverID];
    ids.sort();
    return ids.join('_');
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Container(
            decoration: BoxDecoration(
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
              onTap: () => selectedMessageIds.isEmpty
                  ? Navigator.of(context).pop()
                  : deselectAllMessages(),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: FutureBuilder<String>(
                future: getNameById(widget.receiverID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        snapshot.data ?? 'Usuário',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  } else {
                    return const Text('Carregando...');
                  }
                },
              ),
            ),
            FutureBuilder<String>(
              future: getAvatarById(widget.receiverID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: snapshot.data != ''
                          ? Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                            )
                          : const Icon(Icons.person),
                    ),
                  );
                } else {
                  return const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person),
                  );
                }
              },
            ),
          ],
        ),
        actions: selectedMessageIds.isEmpty
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    for (var messageId in selectedMessageIds) {
                      DocumentReference docRef = chatRoomsCollection
                          .doc(getChatRoomId())
                          .collection('messages')
                          .doc(messageId);
                      docRef.get().then((DocumentSnapshot doc) {
                        if (doc.exists) {
                          Map<String, dynamic>? data =
                              doc.data() as Map<String, dynamic>?;
                          if (data != null) {
                            String message = data['message'];
                            copyMessage(message);
                          }
                        }
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteMessage(
                        selectedMessageIds, selectedMessageIds.length);
                  },
                ),
              ],
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _chatServices.getMessages(userID, widget.receiverID),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Error");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _markMessagesAsSeen();
              });

              return Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot? nextDoc =
                        index > 0 ? snapshot.data!.docs[index - 1] : null;
                    return _buildMessageItem(
                        snapshot.data!.docs[index], nextDoc);
                  },
                ),
              );
            },
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc, DocumentSnapshot? nextDoc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Map<String, dynamic>? nextData = nextDoc?.data() as Map<String, dynamic>?;

    final user = FirebaseAuth.instance.currentUser!;
    bool isCurrentUser = data['senderID'] == user.uid;
    bool isSameUserAsNext =
        nextData != null && data['senderID'] == nextData['senderID'];
    String messageId = doc.id;

    bool isSelected = selectedMessageIds.contains(messageId);

    double marginBottom = isSameUserAsNext ? 2 : 16;

    Timestamp timestamp = data['timestamp'] as Timestamp;
    bool isSeen = data['isSeen'] ?? false;

    return GestureDetector(
      onLongPress: () {
        if (!onLongPressSelection) {
          selectMessage(messageId);
          onLongPressSelection = true;
        }
      },
      onTap: () {
        if (onLongPressSelection) {
          selectMessage(messageId);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: marginBottom),
        child: ExpandableMessage(
          message: data['message'],
          isCurrentUser: isCurrentUser,
          isSelected: isSelected,
          timestamp: formatTimestamp(timestamp),
          isSeen: isSeen,
        ),
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
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
  final String timestamp;
  final bool isSeen;

  const ExpandableMessage({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.isSelected,
    required this.timestamp,
    required this.isSeen,
  });

  @override
  _ExpandableMessageState createState() => _ExpandableMessageState();
}

class _ExpandableMessageState extends State<ExpandableMessage> {
  int maxLength = 500;

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      message: _buildMessage(widget.message),
      isCurrentUser: widget.isCurrentUser,
      isSelected: widget.isSelected,
      timestamp: widget.timestamp,
      isSeen: widget.isSeen,
    );
  }

  Widget _buildMessage(String message) {
    if (message.length > maxLength) {
      return RichText(
        text: TextSpan(
          text: message.substring(0, maxLength), // Estilo da mensagem
          children: [
            TextSpan(
              text: "... ver mais",
              style: const TextStyle(
                  color: Color.fromARGB(
                      255, 64, 0, 167)), // Estilo do link "ver mais"
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
      return Text(
        message,
        style: TextStyle(
            color: widget.isCurrentUser ? Colors.white : Colors.black,
            fontFamily: 'Inter'),
      );
    }
  }
}

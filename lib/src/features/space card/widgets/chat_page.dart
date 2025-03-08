import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/space%20card/widgets/expandable_message.dart';
import 'package:festou/src/services/chat_services.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

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
  final FocusNode messageFocusNode = FocusNode();
  final messageEC = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  Set<String> selectedMessageIds = {};
  final CollectionReference chatRoomsCollection =
      FirebaseFirestore.instance.collection('chat_rooms');
  bool onLongPressSelection = false;
  int counterSelection = 0;
  bool isEmojiVisible = false;
  bool notWait = false;
  String userID = FirebaseAuth.instance.currentUser!.uid;
  bool isTyping = false;
  Timer? _writingTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    messageEC.dispose();
    _writingTimer?.cancel();
    super.dispose();
  }

  Future<void> _markMessagesAsSeen() async {
    await _chatServices.markMessagesAsSeen(widget.receiverID);
  }

  void sendMessage() async {
    if (messageEC.text.isNotEmpty) {
      _chatServices.sendMessage(widget.receiverID, messageEC.text);
      messageEC.clear();
    }
  }

  void selectMessage(String messageId) {
    setState(() {
      notWait = true;
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

  void copyMessage() {
    if (selectedMessageIds.isNotEmpty) {
      List<Future<Map<String, dynamic>>> messageFutures = selectedMessageIds
          .map((messageId) {
            DocumentReference docRef = chatRoomsCollection
                .doc(getChatRoomId())
                .collection('messages')
                .doc(messageId);
            return docRef.get().then((DocumentSnapshot doc) async {
              if (doc.exists) {
                Map<String, dynamic>? data =
                    doc.data() as Map<String, dynamic>?;
                if (data != null) {
                  String senderID = data['senderID'];
                  String message = data['message'];
                  Timestamp timestamp = data['timestamp'];
                  String formattedDate = formatDate(timestamp.toDate());
                  String formattedTime = formatTime(timestamp.toDate());
                  String senderName;

                  if (senderID == userID) {
                    senderName = "Você";
                  } else {
                    senderName = await getNameById(senderID);
                  }

                  return {
                    'formattedMessage':
                        "$senderName diz em $formattedDate, $formattedTime: $message",
                    'timestamp': timestamp
                  };
                }
              }
              return {'formattedMessage': '', 'timestamp': Timestamp.now()};
            }).catchError((error) {
              return {'formattedMessage': '', 'timestamp': Timestamp.now()};
            });
          })
          .toList()
          .cast<Future<Map<String, dynamic>>>();

      Future.wait(messageFutures).then((List<Map<String, dynamic>> messages) {
        messages.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
        String combinedMessage =
            messages.map((message) => message['formattedMessage']).join('\n');
        Clipboard.setData(ClipboardData(text: combinedMessage));
        deselectAllMessages();
        Messages.showSuccess2(
            counterSelection > 1 ? 'Mensagens copiadas' : 'Mensagem copiada',
            context);
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String formatTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}h";
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
          DocumentSnapshot snapshot =
              await messageCollection.doc(messageId).get();
          if (snapshot.exists) {
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
            if (data['senderID'] == userID) {
              if (data['deletionRecipient'] == true) {
                await messageCollection.doc(messageId).delete();
              } else {
                await messageCollection
                    .doc(messageId)
                    .update({'deletionSender': true});
              }
            } else {
              if (data['deletionSender'] == true) {
                await messageCollection.doc(messageId).delete();
              } else {
                await messageCollection
                    .doc(messageId)
                    .update({'deletionRecipient': true});
              }
            }
          }
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
              Messages.showSuccess2('Conversa apagada', context);
            }
          }
        } else {
          deselectAllMessages();
          setState(() {
            notWait = true;
          });

          Messages.showSuccess2(
              counterSelection > 1
                  ? 'Mensagens excluídas'
                  : 'Mensagem excluída',
              context);
        }
      }
    } catch (e) {
      Messages.showError('Erro ao excluir mensagem: $e', context);
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
      return userDocument.docs[0];
    }

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
    _chatServices.getChatRoomId(userID, widget.receiverID);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
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
            Expanded(
              child: FutureBuilder<String>(
                future: getNameById(widget.receiverID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      snapshot.data ?? 'Usuário',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
            FutureBuilder<String>(
              future: getAvatarById(widget.receiverID),
              builder: (context, snapshotPhoto) {
                final avatarUrl = snapshotPhoto.data ?? '';
                return avatarUrl.isNotEmpty
                    ? GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return FutureBuilder<String>(
                                  future: getNameById(widget.receiverID),
                                  builder: (context, snapshotName) {
                                    return Scaffold(
                                      appBar: AppBar(
                                        title: Text(
                                          snapshotName.data != null
                                              ? "${snapshotName.data}"
                                              : '',
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ),
                                      backgroundColor: Colors.black,
                                      body: AlertDialog(
                                          contentPadding:
                                              EdgeInsetsDirectional.zero,
                                          content: Hero(
                                            tag: 'x',
                                            child: Image.network(
                                              avatarUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                    );
                                  });
                            },
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: Hero(
                              tag: 'x',
                              child: Image.network(
                                avatarUrl,
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container();
              },
            ),
          ],
        ),
        actions: selectedMessageIds.isEmpty
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: copyMessage,
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
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !notWait) {
                return const Expanded(child: Text(""));
              }
              notWait = false;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _markMessagesAsSeen();
              });

              List<DocumentSnapshot> filteredDocs =
                  snapshot.data!.docs.where((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return !((data['receiverID'] == userID &&
                        data['deletionRecipient'] == true) ||
                    (data['senderID'] == userID &&
                        data['deletionSender'] == true));
              }).toList();

              return Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot? nextDoc =
                        index > 0 ? filteredDocs[index - 1] : null;
                    return _buildMessageItem(filteredDocs[index], nextDoc);
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

    Timestamp? timestamp;
    if (data.containsKey('timestamp') && data['timestamp'] != null) {
      timestamp = data['timestamp'] as Timestamp;
    } else {
      timestamp = Timestamp.now();
    }
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14, bottom: 4, right: 8),
          child: Row(
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          isEmojiVisible
                              ? 'lib/assets/images/icon_teclado.png'
                              : 'lib/assets/images/icon_emoji.png',
                          width: 25,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isEmojiVisible) {
                              isEmojiVisible = false;
                              notWait = true;
                              FocusScope.of(context)
                                  .requestFocus(messageFocusNode);
                            } else {
                              isEmojiVisible = true;
                              notWait = true;
                              FocusScope.of(context).unfocus();
                            }
                          });
                        },
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: messageFocusNode,
                          controller: messageEC,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Mensagem',
                          ),
                          onTap: () {
                            if (isEmojiVisible) {
                              setState(() {
                                isEmojiVisible = false;
                              });
                            }
                          },
                          minLines: 1,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: sendMessage,
                icon: Image.asset('lib/assets/images/imagem_enviar.png',
                    width: 45),
              ),
            ],
          ),
        ),
        Offstage(
          offstage: !isEmojiVisible,
          child: SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                setState(() {
                  messageEC.text += emoji.emoji;
                  notWait = true;
                });
              },
              config: Config(
                emojiViewConfig: const EmojiViewConfig(
                  columns: 8,
                  emojiSizeMax: 32.0,
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  gridPadding: EdgeInsets.zero,
                  recentsLimit: 32,
                  replaceEmojiOnLimitExceed: false,
                  noRecents: DefaultNoRecentsWidget,
                  buttonMode: ButtonMode.MATERIAL,
                ),
                bottomActionBarConfig: BottomActionBarConfig(
                  showBackspaceButton: true,
                  customBottomActionBar: (config, state, showSearchView) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search,
                              color: Color(0xFF9747FF)),
                          onPressed: showSearchView,
                        ),
                        IconButton(
                          icon: const Icon(Icons.backspace,
                              color: Color(0xFF9747FF)),
                          onPressed: () {
                            setState(() {
                              if (messageEC.text.isNotEmpty) {
                                notWait = true;
                                messageEC.text = messageEC.text.characters
                                    .skipLast(1)
                                    .toString();
                              }
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/chat_bubble.dart';
import 'package:git_flutter_festou/src/services/chat_services.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

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
              Messages.showSuccess2('Conversa apagada', context);
            }
          }
        } else {
          deselectAllMessages();
          setState(() {
            notWait = true;
          });

          Messages.showSuccess2('Mensagem excluída', context);
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
                  //if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      snapshot.data ?? 'Usuário',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                  /*} else {
                    return const Text('Carregando...');
                  }*/
                },
              ),
            ),
            FutureBuilder<String>(
              future: getAvatarById(widget.receiverID),
              builder: (context, snapshotPhoto) {
                //if (snapshot.connectionState == ConnectionState.done) {
                return GestureDetector(
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
                                    contentPadding: EdgeInsetsDirectional.zero,
                                    content: Hero(
                                      tag: 'x',
                                      child: Image.network(
                                        snapshotPhoto.data!,
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
                      child: snapshotPhoto.data != null
                          ? Hero(
                              tag: 'x',
                              child: Image.network(
                                snapshotPhoto.data!,
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              ),
                            )
                          : const Icon(Icons.person),
                    ),
                  ),
                );
                /*} else {
                  return const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person),
                  );
                }*/
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
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !notWait) {
                return const Text("Loading");
              }
              notWait = false;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _markMessagesAsSeen();
              });

              return Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount:
                      snapshot.data == null ? 0 : snapshot.data!.docs.length,
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
                              ? 'lib/assets/images/keyboard.png'
                              : 'lib/assets/images/emoji.png',
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: sendMessage,
                icon: Image.asset('lib/assets/images/send.png', width: 45),
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

  bool isSingleEmoji(String message) {
    RegExp singleEmojiRegex = RegExp(
      r'^(?:'
      r'[\u2700-\u27BF]|'
      r'[\u1F300-\u1F5FF]|'
      r'[\u1F600-\u1F64F]|'
      r'[\u1F680-\u1F6FF]|'
      r'[\u1F700-\u1F77F]|'
      r'[\u1F780-\u1F7FF]|'
      r'[\u1F800-\u1F8FF]|'
      r'[\u1F900-\u1F9FF]|'
      r'[\u1FA00-\u1FA6F]|'
      r'[\u1FA70-\u1FAFF]|'
      r'[\u1FB00-\u1FBFF]|'
      r'[\u1FC00-\u1FCFF]|'
      r'[\u1FD00-\u1FDFF]|'
      r'[\u1FE00-\u1FEFF]|'
      r'[\u1FF00-\u1FFFF]|'
      r'[\u2600-\u26FF]|'
      r'[\u2702-\u27B0]|'
      r'[\u1F1E6-\u1F1FF]|'
      r'\uD83C[\uDDE6-\uDDFF]|'
      r'[\uD83D\uDC00-\uD83D\uDE4F]|'
      r'[\uD83D\uDE80-\uD83D\uDEF6]|'
      r'[\uD83E\uDD00-\uD83E\uDDFF]|'
      r'[\uD83E\uDE00-\uD83E\uDE4F]|'
      r'[\uD83E\uDE80-\uD83E\uDEFF]|'
      r'[\uD83C\uDF00-\uD83D\uDDFF]|'
      r'[\uD83C\uDDE6-\uD83C\uDDFF]{2}|'
      r'\uD83C\uDFF3\uFE0F\u200D\uD83C\uDF08|'
      r'\u261D|'
      r'\u26F9|'
      r'\u270A|'
      r'\u270B|'
      r'\u270C|'
      r'\u270D|'
      r'[\u2B05-\u2B07]|'
      r'[\u2934-\u2935]|'
      r'[\u2B06-\u2B07]|'
      r'[\u3297-\u3299]|'
      r'[\u25AA-\u25AB]|'
      r'[\u25FB-\u25FE]'
      r')$',
      unicode: true,
    );
    return singleEmojiRegex.hasMatch(message);
  }

  List<InlineSpan> _parseMessage(String message) {
    List<InlineSpan> spans = [];
    RegExp emojiRegex = RegExp(
      r'([\u2700-\u27BF]|[\u1F300-\u1F5FF]|[\u1F600-\u1F64F]|[\u1F680-\u1F6FF]|[\u1F700-\u1F77F]|[\u1F780-\u1F7FF]|[\u1F800-\u1F8FF]|[\u1F900-\u1F9FF]|[\u1FA00-\u1FA6F]|\u{1F1E6}-\u{1F1FF}|\u{1F3FB}-\u{1F3FF}|\u{1F3F4}-\u{1F3F4}\u{E0067}-\u{E007F}|\u{E0067}-\u{E007F}|[\u1F1E6-\u1F1FF])+',
      unicode: true,
    );

    bool singleEmoji = isSingleEmoji(message);

    message.splitMapJoin(
      emojiRegex,
      onMatch: (Match match) {
        spans.add(TextSpan(
          text: match.group(0),
          style: TextStyle(
              color: widget.isCurrentUser ? Colors.white : Colors.black,
              fontSize: 16),
        ));
        return '';
      },
      onNonMatch: (String text) {
        spans.add(TextSpan(
          text: text,
          style: TextStyle(
            color: widget.isCurrentUser ? Colors.white : Colors.black,
            fontSize: singleEmoji ? 80 : 22,
          ),
        ));
        return '';
      },
    );

    return spans;
  }

  Widget _buildMessage(String message) {
    if (message.startsWith('http') && (message.endsWith('.gif'))) {
      return Image.network(message);
    } else {
      if (message.length > maxLength) {
        return RichText(
          text: TextSpan(
            children: [
              ..._parseMessage(message.substring(0, maxLength)),
              TextSpan(
                text: "... ver mais",
                style: TextStyle(
                  color: widget.isCurrentUser ? Colors.white : Colors.black,
                ),
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
        return RichText(
          text: TextSpan(
            children: _parseMessage(message),
            style: TextStyle(
              color: widget.isCurrentUser ? Colors.white : Colors.black,
            ),
          ),
        );
      }
    }
  }
}

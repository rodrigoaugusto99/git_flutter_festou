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

  late Stream<QuerySnapshot> chatsStream;
  Set<String> selectedChatRoomIds = {};
  bool onLongPressSelection = false;
  int counterSelection = 0;

  @override
  void initState() {
    super.initState();
    chatsStream = getChatRooms();
  }

  Stream<QuerySnapshot> getChatRooms() {
    final currentUserID = _auth.currentUser!.uid;
    return _firestore
        .collection('chat_rooms')
        .where('chatRoomIDs', arrayContains: currentUserID)
        .snapshots();
  }

  Stream<QuerySnapshot> getLastMessage(String chatRoomID) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }

  Stream<int> getUnreadMessagesCount(String chatRoomID) {
    final currentUserID = _auth.currentUser!.uid;
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .where('isSeen', isEqualTo: false)
        .where('receiverID', isEqualTo: currentUserID)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
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

  void selectChatRoom(String chatRoomId) {
    setState(() {
      if (selectedChatRoomIds.contains(chatRoomId)) {
        selectedChatRoomIds.remove(chatRoomId);
        counterSelection--;
        if (counterSelection == 0) {
          onLongPressSelection = false;
        }
      } else {
        selectedChatRoomIds.add(chatRoomId);
        counterSelection++;
      }
    });
  }

  void deselectAllChatRooms() {
    setState(() {
      selectedChatRoomIds.clear();
      onLongPressSelection = false;
      counterSelection = 0;
    });
  }

  Future<void> deleteSelectedChatRooms() async {
    for (var chatRoomId in selectedChatRoomIds) {
      await _firestore.collection('chat_rooms').doc(chatRoomId).delete();
    }
    deselectAllChatRooms();
    setState(() {
      chatsStream = getChatRooms();
    });
  }

  String formatMessageDate(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));

    if (dateTime.isAfter(today)) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (dateTime.isAfter(yesterday)) {
      return 'Ontem';
    } else {
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF0F0F0),
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
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => onLongPressSelection
                  ? deselectAllChatRooms()
                  : Navigator.of(context).pop(),
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
        backgroundColor: const Color(0XFFF0F0F0),
        actions: onLongPressSelection
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    bool? confirmDeletion = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirmar Exclusão'),
                          content: const Text(
                              'Tem certeza que deseja apagar as conversas selecionadas?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
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

                    if (confirmDeletion == true) {
                      await deleteSelectedChatRooms();
                    }
                  },
                ),
              ]
            : [],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoadingIndicator();
          } else if (snapshot.hasError) {
            return const Text('Erro ao carregar os dados');
          } else {
            return buildChatRoomList(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget buildChatRoomList(QuerySnapshot chats) {
    List<DocumentSnapshot> chatRooms = chats.docs;
    chatRooms.sort((a, b) {
      Timestamp aTimestamp =
          (a.data() as Map<String, dynamic>)['lastMessageTimestamp'];
      Timestamp bTimestamp =
          (b.data() as Map<String, dynamic>)['lastMessageTimestamp'];
      return bTimestamp.compareTo(aTimestamp);
    });

    return ListView.builder(
      padding: const EdgeInsets.only(top: 20),
      itemCount: chatRooms.length,
      itemBuilder: (context, index) {
        final chatRoom = chatRooms[index];
        final chatRoomData = chatRoom.data() as Map<String, dynamic>;
        final chatRoomIDs = chatRoomData['chatRoomIDs'] as List<dynamic>;
        final currentUserID = _auth.currentUser!.uid;

        bool idsIguais =
            chatRoomIDs.every((element) => element == chatRoomIDs[0]);

        Future<String>? otherNameFuture;
        Future<String>? otherAvatarFuture;
        Stream<int>? unreadMessagesCountStream;
        String name = '';
        String otherUserID = '';

        if (!idsIguais) {
          otherUserID = chatRoomIDs.firstWhere((id) => id != currentUserID);
          otherNameFuture = getNameById(otherUserID);
          otherAvatarFuture = getAvatarById(otherUserID);
        } else {
          name = 'Você';
          otherUserID = currentUserID;
          otherAvatarFuture = getAvatarById(currentUserID);
        }
        unreadMessagesCountStream = getUnreadMessagesCount(chatRoom.id);

        return FutureBuilder<String>(
          future: otherNameFuture,
          builder: (context, snapshot) {
            if (idsIguais) {
              name = 'Você';
            } else {
              name = snapshot.data ?? '';
            }

            return StreamBuilder<QuerySnapshot>(
              stream: getLastMessage(chatRoom.id),
              builder: (context, messageSnapshot) {
                if (messageSnapshot.hasError) {
                  return const Text('Erro ao carregar a mensagem');
                } else if (!messageSnapshot.hasData ||
                    messageSnapshot.data!.docs.isEmpty) {
                  return Container();
                } else {
                  final lastMessageData = messageSnapshot.data!.docs.first
                      .data() as Map<String, dynamic>;
                  final lastMessage = lastMessageData['message']
                      .replaceAll('\n', ' ') as String;
                  final lastMessageTime =
                      (lastMessageData['timestamp'] as Timestamp).toDate();

                  return FutureBuilder<String>(
                    future: otherAvatarFuture,
                    builder: (context, avatarSnapshot) {
                      String avatarUrl = avatarSnapshot.data ?? '';

                      return StreamBuilder<int>(
                        stream: unreadMessagesCountStream,
                        builder: (context, unreadSnapshot) {
                          int unreadCount = unreadSnapshot.data ?? 0;

                          return GestureDetector(
                            onLongPress: () {
                              if (!onLongPressSelection) {
                                selectChatRoom(chatRoom.id);
                                onLongPressSelection = true;
                              }
                            },
                            onTap: () {
                              if (onLongPressSelection) {
                                selectChatRoom(chatRoom.id);
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      receiverID: otherUserID,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              color: selectedChatRoomIds.contains(chatRoom.id)
                                  ? Colors.grey.withOpacity(0.5)
                                  : Colors.white,
                              alignment: Alignment.center,
                              height: 95,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: avatarUrl.isNotEmpty
                                        ? NetworkImage(avatarUrl)
                                        : null,
                                    backgroundColor: avatarUrl.isNotEmpty
                                        ? Colors.transparent
                                        : const Color(0XFFF0F0F0),
                                    radius: 35,
                                    child: avatarUrl.isEmpty
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              formatMessageDate(
                                                  lastMessageTime),
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                lastMessage,
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            if (unreadCount > 0)
                                              CircleAvatar(
                                                backgroundColor: Colors.purple,
                                                radius: 10,
                                                child: Text(
                                                  unreadCount.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}

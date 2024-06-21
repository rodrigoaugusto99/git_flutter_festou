import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/chat_page.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import '../../loading_indicator.dart';

class Mensagens extends StatefulWidget {
  const Mensagens({super.key});

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference chatRoomsCollection =
      FirebaseFirestore.instance.collection('chat_rooms');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  Map<String, StreamSubscription> _messageListeners = {};
  late Stream<QuerySnapshot> chatsStream;
  Set<String> selectedChatRoomIds = {};
  bool onLongPressSelection = false;
  int counterSelection = 0;

  @override
  void initState() {
    super.initState();
    chatsStream = getChatRooms();
  }

  @override
  void dispose() {
    _cancelAllMessageListeners();
    super.dispose();
  }

  void _cancelAllMessageListeners() {
    for (var listener in _messageListeners.values) {
      listener.cancel();
    }
    _messageListeners.clear();
  }

  Stream<QuerySnapshot> getChatRooms() {
    final currentUserID = _auth.currentUser!.uid;
    return _firestore
        .collection('chat_rooms')
        .where('chatRoomIDs', arrayContains: currentUserID)
        .snapshots();
  }

  void listenForNewMessages(String chatRoomID) {
    final currentUserID = _auth.currentUser!.uid;

    if (_messageListeners.containsKey(chatRoomID)) {
      _messageListeners[chatRoomID]?.cancel();
    }

    final subscription = _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .where('receiverID', isEqualTo: currentUserID)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        print('Nova mensagem recebida no chat room $chatRoomID');
        _firestore.collection('chat_rooms').doc(chatRoomID).update({
          'deletionID$currentUserID': false,
        });
      }
    });

    _messageListeners[chatRoomID] = subscription;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String chatRoomID) async {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    // Consulta para mensagens enviadas pelo currentUserID com deletionSender false
    var senderQuerySnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .where('senderID', isEqualTo: currentUserID)
        .where('deletionSender', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    // Consulta para mensagens recebidas pelo currentUserID com deletionRecipient false
    var receiverQuerySnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .where('receiverID', isEqualTo: currentUserID)
        .where('deletionRecipient', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    // Verifique se ambas as consultas retornaram documentos
    if (senderQuerySnapshot.docs.isNotEmpty &&
        receiverQuerySnapshot.docs.isNotEmpty) {
      // Compare os timestamps dos documentos mais recentes de cada consulta
      var senderTimestamp =
          senderQuerySnapshot.docs.first['timestamp'] as Timestamp;
      var receiverTimestamp =
          receiverQuerySnapshot.docs.first['timestamp'] as Timestamp;

      if (senderTimestamp.compareTo(receiverTimestamp) > 0) {
        return senderQuerySnapshot;
      } else {
        return receiverQuerySnapshot;
      }
    } else if (senderQuerySnapshot.docs.isNotEmpty) {
      return senderQuerySnapshot;
    } else {
      return receiverQuerySnapshot;
    }
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getLastMessages(
      String chatRoomID) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      final currentUserID = _auth.currentUser!.uid;
      return snapshot.docs.where((doc) {
        final data = doc.data();
        if (data['senderID'] == currentUserID && data['deletionSender']) {
          return false;
        }
        if (data['receiverID'] == currentUserID && data['deletionRecipient']) {
          return false;
        }
        return true;
      }).toList();
    });
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

  Future<DocumentSnapshot> getUserDocumentById(String userId) async {
    final userDocument =
        await usersCollection.where('uid', isEqualTo: userId).get();

    if (userDocument.docs.isNotEmpty) {
      return userDocument.docs[0];
    }

    throw Exception("Usuário não encontrado");
  }

  Future<UserModel> getUserById(String id) async {
    final userDocument = await getUserDocumentById(id);
    final userData = userDocument.data() as Map<String, dynamic>;
    return UserModel.fromMap(userData, userDocument.id);
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
        onLongPressSelection = true; // Adicione esta linha
      }
      print('selectedChatRoomIds: $selectedChatRoomIds');
      print('counterSelection: $counterSelection');
      print('onLongPressSelection: $onLongPressSelection');
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
    final currentUserID = _auth.currentUser!.uid;

    for (var chatRoomId in selectedChatRoomIds) {
      var ids = chatRoomId.split('_');

      final messageCollection =
          chatRoomsCollection.doc(chatRoomId).collection('messages');

      QuerySnapshot allMessagesSnapshot = await messageCollection.get();

      for (var doc in allMessagesSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['senderID'] == currentUserID) {
          if (data['deletionRecipient'] == true) {
            await messageCollection.doc(doc.id).delete();
          } else {
            await messageCollection
                .doc(doc.id)
                .update({'deletionSender': true});
          }
        } else {
          if (data['deletionSender'] == true) {
            await messageCollection.doc(doc.id).delete();
          } else {
            await messageCollection
                .doc(doc.id)
                .update({'deletionRecipient': true});
          }
        }
      }

      DocumentReference<Map<String, dynamic>> chatRoomDocRef =
          _firestore.collection('chat_rooms').doc(chatRoomId);

      String otherUserID = ids.firstWhere((id) => id != currentUserID);

      DocumentSnapshot<Map<String, dynamic>> chatRoomDoc =
          await chatRoomDocRef.get();

      Map<String, dynamic>? chatRoomData = chatRoomDoc.data();

      if (chatRoomData != null &&
          chatRoomData['deletionID$otherUserID'] == true) {
        await chatRoomDocRef.delete();
      } else if (chatRoomData != null) {
        await chatRoomDocRef.update({'deletionID$currentUserID': true});
      }
    }

    deselectAllChatRooms();
    setState(() {
      chatsStream = getChatRooms();
    });
  }

  String formatMessageDate(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

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
    final currentUserID = _auth.currentUser!.uid;
    return FutureBuilder<UserModel>(
      future: getUserById(currentUserID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomLoadingIndicator();
        } else if (snapshot.hasError) {
          return const Text('Erro ao carregar o usuário');
        } else if (!snapshot.hasData) {
          return const Text('Usuário não encontrado');
        } else {
          UserModel user = snapshot.data!;
          return Scaffold(
            backgroundColor: const Color(0XFFF0F0F0),
            appBar: AppBar(
              leading: user.locador
                  ? Padding(
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
                    )
                  : Container(),
              centerTitle: true,
              title: const Text(
                'Mensagens',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
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
                  /*final filteredDocs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return data['deletionID$currentUserID'] != true;
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return const Text('Nenhum dado encontrado');
                  }

                  print('Dados carregados com sucesso.');
                  return buildChatRoomListFromDocs(filteredDocs);*/
                }
              },
            ),
          );
        }
      },
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

            return StreamBuilder<
                List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              stream: getLastMessages(chatRoom.id),
              builder: (context, messageSnapshot) {
                if (messageSnapshot.hasError) {
                  print(
                      'Erro ao carregar a mensagem: ${messageSnapshot.error}');
                  return const Text('Erro ao carregar a mensagem');
                } else if (!messageSnapshot.hasData ||
                    messageSnapshot.data!.isEmpty) {
                  return Container();
                } else {
                  String lastMessage = '';
                  DateTime? lastMessageTime;
                  for (var chat in messageSnapshot.data!) {
                    final lastMessageData = chat.data();
                    if (lastMessageData['senderID'] == currentUserID &&
                        lastMessageData['deletionSender']) {
                      continue;
                    } else if (lastMessageData['receiverID'] == currentUserID &&
                        lastMessageData['deletionRecipient']) {
                      continue;
                    } else {
                      lastMessage = lastMessageData['message']
                          .replaceAll('\n', ' ') as String;

                      if (lastMessageData['timestamp'] != null) {
                        lastMessageTime =
                            (lastMessageData['timestamp'] as Timestamp)
                                .toDate();
                      } else {
                        lastMessageTime = DateTime.now();
                      }
                      break; // Encontramos a última mensagem válida, podemos sair do loop
                    }
                  }

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
                                            if (lastMessageTime != null)
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

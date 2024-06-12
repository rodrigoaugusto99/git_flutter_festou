import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/models/message_model.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    MessageModel newMessage = MessageModel(
      senderID: currentUserID,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
      isSeen: false, // Inicialmente, a mensagem não foi vista
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Adiciona ou atualiza o documento do chat room com a lista chatRoomIDs e o campo lastMessageTimestamp
    await _firestore.collection('chat_rooms').doc(chatRoomID).set(
        {
          'chatRoomIDs': ids,
          'lastMessageTimestamp':
              timestamp, // Atualiza o timestamp da última mensagem
          'isTyping': false // Inicializa o campo isTyping
        },
        SetOptions(
            merge:
                true)); // Utiliza merge para não sobrescrever campos existentes

    // Adiciona a mensagem à coleção messages no mesmo documento
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Future<void> setTypingStatus(String receiverID, bool isTyping) async {
    final String currentUserID = _auth.currentUser!.uid;
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .set({'isTyping': isTyping}, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot> getTypingStatus(String chatRoomID) {
    return _firestore.collection('chat_rooms').doc(chatRoomID).snapshots();
  }

  String getChatRoomId(String userID, String receiverID) {
    List<String> ids = [userID, receiverID];
    ids.sort();
    return ids.join('_');
  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> markMessagesAsSeen(String receiverID) async {
    final String currentUserID = _auth.currentUser!.uid;

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    QuerySnapshot messagesSnapshot = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .where('receiverID', isEqualTo: currentUserID)
        .where('isSeen', isEqualTo: false)
        .get();

    for (var doc in messagesSnapshot.docs) {
      await doc.reference.update({'isSeen': true});
    }
  }
}

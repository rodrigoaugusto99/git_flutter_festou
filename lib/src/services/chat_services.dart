import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Adiciona a mensagem à coleção messages no mesmo documento
    DocumentReference messageRef = _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .doc();

    await messageRef.set({
      'senderID': currentUserID,
      'receiverID': receiverID,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isSeen': false
    });

    // Obtém o timestamp do servidor
    DocumentSnapshot messageSnap = await messageRef.get();
    if (messageSnap.exists && messageSnap.data() != null) {
      Timestamp serverTimestamp = messageSnap['timestamp'];

      // Atualiza o documento do chat room com o último timestamp da mensagem
      await _firestore.collection('chat_rooms').doc(chatRoomID).set(
          {'chatRoomIDs': ids, 'lastMessageTimestamp': serverTimestamp},
          SetOptions(merge: true));
    }
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

    WriteBatch batch = _firestore.batch();

    //O Firestore tem um limite de 500 operações por batch.
    //Se for preciso atualizar mais de 500 documentos,
    //precisará dividir as operações em múltiplos batches.
    for (var doc in messagesSnapshot.docs) {
      batch.update(doc.reference, {'isSeen': true});
    }

    await batch.commit();
  }
}

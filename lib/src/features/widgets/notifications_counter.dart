import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class NotificationCounter {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final BehaviorSubject<int> _notificationCount =
      BehaviorSubject<int>.seeded(0);

  Stream<int> get notificationCount => _notificationCount.stream;

  NotificationCounter() {
    _init();
  }

  void _init() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      _firestore
          .collection('chat_rooms')
          .where('chatRoomIDs', arrayContains: currentUser.uid)
          .snapshots()
          .listen((chatRoomsSnapshot) {
        if (chatRoomsSnapshot.docs.isEmpty) {
          _updateNotificationCount(0);
          return;
        }

        List<Stream<QuerySnapshot>> messageStreams = chatRoomsSnapshot.docs
            .map((doc) => doc.reference
                .collection('messages')
                .where('receiverID', isEqualTo: currentUser.uid)
                .where('isSeen', isEqualTo: false)
                .snapshots())
            .toList();

        Rx.combineLatest(messageStreams, (List<QuerySnapshot> list) => list)
            .listen((List<QuerySnapshot> snapshots) {
          int unreadCount = snapshots.fold(
              0, (sum, querySnapshot) => sum + querySnapshot.docs.length);
          _updateNotificationCount(unreadCount);
          _updateNotificationCountInDB(
              unreadCount); // Adiciona atualização no banco de dados
        });
      });
    }
  }

  void _updateNotificationCount(int count) {
    _notificationCount.add(count);
  }

  void _updateNotificationCountInDB(int count) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: currentUser.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        _firestore.collection('users').doc(docId).update({
          'notifications': count,
        });
      } else {
        // Handle case where no document is found
        print("No user document found for UID: ${currentUser.uid}");
      }
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderID;

  final String receiverID;
  final String message;
  final Timestamp timestamp;

  MessageModel(
      {required this.senderID,
      required this.receiverID,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderID': senderID,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}

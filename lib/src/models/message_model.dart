import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderID;
  final String receiverID;
  final String message;
  final Timestamp timestamp;
  final bool isSeen;

  MessageModel({
    required this.senderID,
    required this.receiverID,
    required this.message,
    required this.timestamp,
    this.isSeen = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
      'isSeen': isSeen,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderID: map['senderID'],
      receiverID: map['receiverID'],
      message: map['message'],
      timestamp: map['timestamp'],
      isSeen: map['isSeen'] ?? false,
    );
  }
}

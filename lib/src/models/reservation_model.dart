import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Festou/src/models/user_model.dart';

class ReservationModel {
  final String? id;
  final String clientId;
  final String locadorId;
  final String spaceId;
  final int checkInTime;
  final int checkOutTime;
  final bool hasReview;
  final Timestamp? createdAt;
  final Timestamp selectedDate;
  final Timestamp selectedFinalDate;
  final String contratoHtml;
  final String? cardId;
  final String? reason;
  final Timestamp? canceledAt;
  UserModel? user;

  ReservationModel({
    required this.spaceId,
    this.id,
    required this.clientId,
    required this.locadorId,
    required this.checkInTime,
    required this.checkOutTime,
    required this.hasReview,
    required this.selectedDate,
    required this.selectedFinalDate,
    this.reason,
    this.createdAt,
    required this.contratoHtml,
    this.cardId,
    this.canceledAt,
    this.user,
  });

  factory ReservationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ReservationModel(
      id: doc.id,
      clientId: data['client_id'] ?? '',
      locadorId: data['locador_id'] ?? '',
      spaceId: data['space_id'] ?? '',
      checkInTime: data['checkInTime'] ?? '',
      checkOutTime: data['checkOutTime'] ?? '',
      hasReview: data['hasReview'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      selectedDate: data['selectedDate'] ?? Timestamp.now(),
      selectedFinalDate: data['selectedFinalDate'] ?? Timestamp.now(),
      contratoHtml: data['contratoHtml'] ?? '',
      cardId: data['cardId'] ?? '',
      reason: data['reason'] ?? '',
    );
  }

  factory ReservationModel.fromMap(Map<String, dynamic> map, String id) {
    return ReservationModel(
      id: id,
      clientId: map['client_id'],
      locadorId: map['locador_id'],
      spaceId: map['spaceId'],
      checkInTime: map['checkInTime'],
      checkOutTime: map['checkOutTime'],
      hasReview: map['hasReview'],
      createdAt: map['createdAt'],
      selectedDate: map['selectedDate'],
      selectedFinalDate: map['selectedFinalDate'],
      contratoHtml: map['contratoHtml'],
      cardId: map['cardId'],
      reason: map['reason'],
    );
  }
}

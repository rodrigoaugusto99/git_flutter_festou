import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  final String clientId;
  final String locadorId;
  final String spaceId;
  final int checkInTime;
  final int checkOutTime;
  final Timestamp? createdAt;
  final String selectedDate;
  final String? selectedFinalDate;
  final String contratoHtml;

  ReservationModel({
    required this.spaceId,
    required this.clientId,
    required this.locadorId,
    required this.checkInTime,
    required this.checkOutTime,
    required this.selectedDate,
    required this.selectedFinalDate,
    this.createdAt,
    required this.contratoHtml,
  });
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  final String clientId;
  final String locadorId;
  final String spaceId;
  final int checkInTime;
  final int checkOutTime;
  final Timestamp? createdAt;
  final Timestamp selectedDate;
  final Timestamp selectedFinalDate;
  final String contratoHtml;
  final String? cardId;

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
    this.cardId,
  });

  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      clientId: map['client_id'],
      locadorId: map['locador_id'],
      spaceId: map['spaceId'],
      checkInTime: map['checkInTime'],
      checkOutTime: map['checkOutTime'],
      createdAt: map['createdAt'],
      selectedDate: map['selectedDate'],
      selectedFinalDate: map['selectedFinalDate'],
      contratoHtml: map['contratoHtml'],
      cardId: map['cardId'],
    );
  }
}

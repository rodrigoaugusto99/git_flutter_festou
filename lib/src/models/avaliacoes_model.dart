// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:festou/src/models/space_model.dart';

class AvaliacoesModel {
  final String id;
  final int rating;
  final String content;
  final String userId;
  final String spaceId;
  final String reservationId;
  final String userName;
  final String date;
  final String avatar;
  List<String> likes;
  List<String> dislikes;
  final SpaceModel? space;
  final Timestamp? deletedAt;

  AvaliacoesModel({
    required this.id,
    required this.rating,
    required this.content,
    required this.spaceId,
    required this.reservationId,
    required this.userId,
    required this.userName,
    required this.date,
    required this.avatar,
    required this.likes,
    required this.dislikes,
    required this.deletedAt,
    this.space,
  });

  AvaliacoesModel copyWith({
    String? id,
    String? spaceId,
    String? userId,
    String? reservationId,
    int? rating,
    String? content,
    String? userName,
    String? date,
    String? avatar,
    List<String>? likes,
    List<String>? dislikes,
    Timestamp? deletedAt,
  }) {
    return AvaliacoesModel(
      id: id ?? this.id,
      spaceId: spaceId ?? this.spaceId,
      reservationId: reservationId ?? this.reservationId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      content: content ?? this.content,
      userName: userName ?? this.userName,
      date: date ?? this.date,
      avatar: avatar ?? this.avatar,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory AvaliacoesModel.fromMap(Map<String, dynamic> map) {
    return AvaliacoesModel(
      id: map['id'] as String,
      rating: map['rating'] as int,
      content: map['content'] as String,
      userId: map['user_id'] as String,
      spaceId: map['space_id'] as String,
      reservationId: map['reservationId'] as String,
      userName: map['user_name'] as String,
      date: map['date'] as String,
      avatar: map['avatar'] as String,
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      dislikes: List<String>.from((map['dislikes'] as List<dynamic>)),
      deletedAt: map['deletedAt'],
    );
  }
}

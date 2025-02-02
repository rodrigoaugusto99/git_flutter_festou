import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class AvaliacoesModel {
  final String id;
  final int rating;
  final String content;
  final String userId;
  final String spaceId;
  final String userName;
  final String date;
  final String avatar;
  final List<String> likes;
  final List<String> dislikes;
  final SpaceModel? space;
  final Timestamp? deletedAt;

  AvaliacoesModel({
    required this.id,
    required this.rating,
    required this.content,
    required this.spaceId,
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
}

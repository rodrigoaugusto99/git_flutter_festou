import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class FeedbackModel {
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

  FeedbackModel({
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
}

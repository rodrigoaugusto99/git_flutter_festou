import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? id;
  String title;
  String description;
  List<String> imagens;
  String coverPhoto;
  Timestamp createdAt;

  PostModel({
    this.id,
    required this.title,
    required this.description,
    required this.imagens,
    required this.coverPhoto,
    required this.createdAt,
  });
}

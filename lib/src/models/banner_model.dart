import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  BannerModel({
    required this.photoUrl,
    required this.index,
  });
  final String photoUrl;
  final int index;

  factory BannerModel.fromDocument(QueryDocumentSnapshot doc) {
    return BannerModel(
      photoUrl: doc['imageUrl'],
      index: doc['index'],
    );
  }
}

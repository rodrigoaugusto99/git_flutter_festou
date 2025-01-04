import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  final Timestamp? createdAt;
  final String cvv;
  final String cardName;
  final String name;
  final String number;
  final String validateDate;
  String? id;

  CardModel({
    this.id,
    this.createdAt,
    required this.cardName,
    required this.cvv,
    required this.name,
    required this.number,
    required this.validateDate,
  });

  // Convert the CardModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'createdAt': FieldValue.serverTimestamp(),
      'cardName': cardName,
      'cvv': cvv,
      'name': name,
      'number': number,
      'validateDate': validateDate,
    };
  }

  // Create a CardModel instance from a map
  factory CardModel.fromMap(Map<String, dynamic> map, String id) {
    return CardModel(
      id: id,
      createdAt: map['createdAt'],
      cardName: map['cardName'],
      cvv: map['cvv'],
      name: map['name'],
      number: map['number'],
      validateDate: map['validateDate'],
    );
  }

  // Save the CardModel instance to Firestore
  Future<String> saveToFirestore() async {
    try {
      final collection = FirebaseFirestore.instance.collection('cards');
      final res = await collection.add(toMap());
      return res.id;
    } catch (e) {
      throw Exception('Failed to save card to Firestore: $e');
    }
  }
}

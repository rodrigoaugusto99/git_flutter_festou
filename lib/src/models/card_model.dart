import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  final String bandeira;
  final Timestamp? createdAt;
  final String cvv;
  final String name;
  final String number;
  final String validate;
  String? id;

  CardModel({
    this.id,
    required this.bandeira,
    this.createdAt,
    required this.cvv,
    required this.name,
    required this.number,
    required this.validate,
  });

  // Convert the CardModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'bandeira': bandeira,
      'createdAt': FieldValue.serverTimestamp(),
      'cvv': cvv,
      'name': name,
      'number': number,
      'validate': validate,
    };
  }

  // Create a CardModel instance from a map
  factory CardModel.fromMap(Map<String, dynamic> map, String id) {
    return CardModel(
      id: id,
      bandeira: map['bandeira'],
      createdAt: map['createdAt'],
      cvv: map['cvv'],
      name: map['name'],
      number: map['number'],
      validate: map['validate'],
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

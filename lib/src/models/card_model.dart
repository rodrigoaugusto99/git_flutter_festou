import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  String? id;
  final Timestamp? createdAt;
  final String cvv;
  final String cardName;
  final String name;
  final String number;
  final String validateDate;

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
      'id': id,
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

  Future<String> saveToFirestore(String userId) async {
    try {
      // Referência à subcoleção `cards` dentro do documento do usuário
      final collection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cards');

      // Adiciona o cartão e obtém o ID gerado pelo Firestore para retornar
      final res = await collection.add(toMap());

      return res.id;
    } catch (e) {
      throw Exception('Failed to save card to Firestore: $e');
    }
  }
}

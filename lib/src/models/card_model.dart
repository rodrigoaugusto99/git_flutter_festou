import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  String? id;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final String cvv;
  final String cardName;
  final String name;
  final String number;
  final String validateDate;

  CardModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.cardName,
    required this.cvv,
    required this.name,
    required this.number,
    required this.validateDate,
  });

  Map<String, dynamic> toMap({bool isUpdate = false}) {
    return {
      'id': id,
      if (!isUpdate)
        'createdAt': FieldValue.serverTimestamp(), // Apenas na criação
      'updatedAt': FieldValue.serverTimestamp(), // Sempre atualizado
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
      updatedAt: map['updatedAt'],
      cardName: map['cardName'],
      cvv: map['cvv'],
      name: map['name'],
      number: map['number'],
      validateDate: map['validateDate'],
    );
  }

  Future<void> saveOrUpdateToFirestore(String userId) async {
    try {
      // Referência à subcoleção `cards` dentro do documento do usuário
      final collection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cards');

      if (id != null) {
        // Atualizar o cartão existente
        await collection.doc(id).update(toMap(isUpdate: true));
      } else {
        // Criar novo cartão
        final res = await collection.add(toMap());
        id = res.id; // Atualiza o ID no modelo
      }
    } catch (e) {
      throw Exception('Failed to save or update card in Firestore: $e');
    }
  }
}

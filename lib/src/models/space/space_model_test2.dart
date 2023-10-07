import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:git_flutter_festou/src/models/feedback/feedback_model_test.dart'; // Certifique-se de importar o modelo FeedbackModel correto aqui.

class SpaceModelTest {
  final String? name;
  final String? email;
  final String? cep;
  final String? logradouro;
  final String? numero;
  final String? bairro;
  final String? cidade;
  final List<String>? selectedTypes;
  final List<String>? selectedServices;
  final List<String>? availableDays;
  final List<FeedbackModel>? feedbackModel; // Use o tipo correto aqui

  SpaceModelTest({
    this.name,
    this.email,
    this.cep,
    this.logradouro,
    this.numero,
    this.bairro,
    this.cidade,
    this.selectedTypes,
    this.selectedServices,
    this.availableDays,
    this.feedbackModel,
  });

  factory SpaceModelTest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()
        as Map<String, dynamic>; // Use 'as' para converter dados para Map
    return SpaceModelTest(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      cep: data['cep'] ?? '',
      logradouro: data['logradouro'] ?? '',
      numero: data['numero'] ?? '',
      bairro: data['bairro'] ?? '',
      cidade: data['cidade'] ?? '',
      selectedTypes: List<String>.from(data['selectedTypes'] ?? []),
      selectedServices: List<String>.from(data['selectedServices'] ?? []),
      availableDays: List<String>.from(data['availableDays'] ?? []),
      feedbackModel: (data['feedbackModel'] as List<dynamic>?)?.map((item) {
            return FeedbackModel.fromMap(item as Map<String, dynamic>);
          }).toList() ??
          [],
    );
  } // Use FeedbackModel.fromMap para criar objetos FeedbackModel a partir dos dados

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "email": email,
      "cep": cep,
      "logradouro": logradouro,
      "numero": numero,
      "bairro": bairro,
      "cidade": cidade,
      "selectedTypes": selectedTypes,
      "selectedServices": selectedServices,
      "availableDays": availableDays,
      "feedbackModel": feedbackModel!.map((item) {
        return item.toMap();
      }).toList(),
    };
  } // Use toMap para converter objetos FeedbackModel em Map
}

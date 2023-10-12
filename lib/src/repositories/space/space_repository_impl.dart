import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import './space_repository.dart';

class SpaceRepositoryImpl implements SpaceRepository {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Future<Either<RepositoryException, Nil>> save(
      ({
        User user,
        Map<String, dynamic> space,
        List<String> selectedTypes,
        List<String> selectedServices,
        List<String> availableDays,
      }) spaceData) async {
    try {
      QuerySnapshot querySnapshot =
          await users.where("uid", isEqualTo: spaceData.user.uid).get();

      if (querySnapshot.docs.length == 1) {
        DocumentReference userDocRef = querySnapshot.docs[0].reference;

        Map<String, dynamic> spaceItem = {
          'name': spaceData.space['name'],
          'email': spaceData.space['email'],
          'space_address': {
            'cep': spaceData.space['cep'],
            'logradouro': spaceData.space['logradouro'],
            'numero': spaceData.space['numero'],
            'bairro': spaceData.space['bairro'],
            'cidade': spaceData.space['cidade'],
          },
          'availableDays': spaceData.availableDays,
          'selectedTypes': spaceData.selectedTypes,
          'selectedServices': spaceData.selectedServices,
        };

        // Crie um mapa para representar os espaços
        Map<String, dynamic> userSpaces = {};
        userSpaces.addAll(spaceItem);

        // Atualize o documento do usuário com o mapa de espaços
        await userDocRef.update({
          'user_spaces': userSpaces,
        });

        log('Informações de usuário adicionadas com sucesso!');
      }
      return Success(nil);
    } catch (e) {
      log('Erro ao adicionar informações de usuário: $e');
      return Failure(RepositoryException(message: 'Erro ao cadastrar usuario'));
    }
  }
}

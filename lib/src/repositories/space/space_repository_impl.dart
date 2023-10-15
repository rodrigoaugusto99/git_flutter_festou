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
        String spaceId,
        User user,
        String email,
        String name,
        String cep,
        String logradouro,
        String numero,
        String bairro,
        String cidade,
        List<String> selectedTypes,
        List<String> selectedServices,
        List<String> availableDays,
      }) spaceData) async {
    try {
      QuerySnapshot querySnapshot =
          await users.where("uid", isEqualTo: spaceData.user.uid).get();

      if (querySnapshot.docs.length == 1) {
        DocumentReference userDocRef = querySnapshot.docs[0].reference;

        // Crie um novo espaço com os dados fornecidos
        Map<String, dynamic> newSpace = {
          'space_id': spaceData.spaceId,
          'emailComercial': spaceData.email,
          'nome_do_espaco': spaceData.name,
          'space_address': {
            'cep': spaceData.cep,
            'logradouro': spaceData.logradouro,
            'numero': spaceData.numero,
            'bairro': spaceData.bairro,
            'cidade': spaceData.cidade,
          },
          'space_infos': {
            'selectedTypes': spaceData.selectedTypes,
            'selectedServices': spaceData.selectedServices,
            'availableDays': spaceData.availableDays,
          },
        };

        // Atualize o documento do usuário com a lista de espaços atualizada
        await userDocRef.update({
          'user_spaces': FieldValue.arrayUnion([newSpace]),
        });

        log('Informações de espaço adicionadas com sucesso!');
      }
      return Success(Nil());
    } catch (e) {
      log('Erro ao adicionar informações de espaço: $e');
      return Failure(RepositoryException(message: 'Erro ao cadastrar espaço'));
    }
  }
}

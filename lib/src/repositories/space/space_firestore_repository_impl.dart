import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/repositories/space/space_firestore_repository.dart';

class SpaceFirestoreRepositoryImpl implements SpaceFirestoreRepository {
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  @override
  Future<Either<RepositoryException, Nil>> saveSpace(
      ({
        String spaceId,
        String userId,
        String email,
        String name,
        String bairro,
        String cep,
        String cidade,
        String logradouro,
        String numero,
        List<String> selectedTypes,
        List<String> selectedServices,
        List<String> availableDays,
      }) spaceData) async {
    try {
      // Crie um novo espaço com os dados fornecidos
      Map<String, dynamic> newSpace = {
        'space_id': spaceData.spaceId,
        'user_id': spaceData.userId,
        'email_do_espaço': spaceData.email,
        'nome_do_espaco': spaceData.name,
        'cep': spaceData.cep,
        'logradouro': spaceData.logradouro,
        'numero': spaceData.numero,
        'bairro': spaceData.bairro,
        'cidade': spaceData.cidade,
        'selectedTypes': spaceData.selectedTypes,
        'selectedServices': spaceData.selectedServices,
        'availableDays': spaceData.availableDays,
      };

      // Insira o espaço na coleção 'spaces'
      await spacesCollection.add(newSpace);

      log('Informações de espaço adicionadas com sucesso!');
      return Success(Nil());
    } catch (e) {
      log('Erro ao adicionar informações de espaço: $e');
      return Failure(RepositoryException(message: 'Erro ao cadastrar espaço'));
    }
  }
}

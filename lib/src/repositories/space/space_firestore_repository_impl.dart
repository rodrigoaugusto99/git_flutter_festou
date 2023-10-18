import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/fp/nil.dart';
import 'package:git_flutter_festou/src/repositories/space/space_firestore_repository.dart';

class SpaceFirestoreRepositoryImpl implements SpaceFirestoreRepository {
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');
  final CollectionReference spaceAddressCollection =
      FirebaseFirestore.instance.collection('space_addresses');
  final CollectionReference spaceInfosCollection =
      FirebaseFirestore.instance.collection('space_infos');

  @override
  Future<Either<RepositoryException, Nil>> saveSpace(
      ({
        String spaceId,
        String userId,
        String email,
        String name,
      }) spaceData) async {
    try {
      // Crie um novo espaço com os dados fornecidos
      Map<String, dynamic> newSpace = {
        'space_id': spaceData.spaceId,
        'email_do_espaço': spaceData.email,
        'nome_do_espaco': spaceData.name,
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

  @override
  Future<Either<RepositoryException, Nil>> saveSpaceAddress(
      ({
        String bairro,
        String cep,
        String cidade,
        String logradouro,
        String numero,
        String spaceId,
      }) spaceAddress) async {
    try {
      // Crie um novo documento de endereço com os dados fornecidos
      Map<String, dynamic> newAddress = {
        'cep': spaceAddress.cep,
        'logradouro': spaceAddress.logradouro,
        'numero': spaceAddress.numero,
        'bairro': spaceAddress.bairro,
        'cidade': spaceAddress.cidade,
      };

      // Insira o endereço na coleção 'space_addresses'
      await spaceAddressCollection.add(newAddress);

      log('Informações de endereço adicionadas com sucesso!');
      return Success(Nil());
    } catch (e) {
      log('Erro ao adicionar informações de endereço: $e');
      return Failure(
          RepositoryException(message: 'Erro ao cadastrar endereço'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> saveSpaceInfos(
      ({
        List<String> availableDays,
        List<String> selectedServices,
        List<String> selectedTypes,
        String spaceId,
      }) spaceInfos) async {
    try {
      // Crie um novo documento de informações de espaço com os dados fornecidos
      Map<String, dynamic> newSpaceInfos = {
        'selectedTypes': spaceInfos.selectedTypes,
        'selectedServices': spaceInfos.selectedServices,
        'availableDays': spaceInfos.availableDays,
      };

      // Insira as informações do espaço na coleção 'space_infos'
      await spaceInfosCollection.add(newSpaceInfos);

      log('Informações de espaço adicionadas com sucesso!');
      return Success(Nil());
    } catch (e) {
      log('Erro ao adicionar informações de espaço: $e');
      return Failure(RepositoryException(
          message: 'Erro ao cadastrar informações do espaço'));
    }
  }
}

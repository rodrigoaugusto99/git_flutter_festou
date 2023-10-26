import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:git_flutter_festou/src/core/exceptions/repository_exception.dart';

import 'package:git_flutter_festou/src/core/fp/either.dart';

import 'package:git_flutter_festou/src/core/fp/nil.dart';

import './images_storage_repository.dart';

class ImagesStorageRepositoryImpl implements ImagesStorageRepository {
  final storage = FirebaseStorage.instance;

  @override
  Future<Either<RepositoryException, Nil>> uploadSpaceImages(
      {required List<File> imageFiles, required String spaceId}) async {
    try {
      // Crie um prefixo para as imagens com base no espaçoId
      final prefix = 'espaços/$spaceId';

      // Faça o upload de cada imagem individualmente
      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];
        var storageRef = storage.ref().child('$prefix/imagem_$i.jpg');

        await storageRef.putFile(imageFile);
      }

      log('Imagens do espaço $spaceId enviadas com sucesso para o Firebase Storage');

      // todo: return?
      return Success(Nil());
    } catch (e) {
      log('Erro ao enviar imagens para o Firebase Storage: $e');
      return Failure(RepositoryException(message: 'Erro ao enviar imagens'));
    }
  }
}

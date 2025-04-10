import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:festou/src/core/exceptions/repository_exception.dart';

import 'package:festou/src/core/fp/either.dart';

import 'package:festou/src/core/fp/nil.dart';

import './images_storage_repository.dart';

class ImagesStorageRepositoryImpl implements ImagesStorageRepository {
  final storage = FirebaseStorage.instance;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Future<Either<RepositoryException, Nil>> uploadSpaceImages(
      {required List<File> imageFiles, required String spaceId}) async {
    try {
      // Crie um prefixo para as imagens com base no espaçoId
      final prefix = 'espaços/$spaceId/images';

      // Faça o upload de cada imagem individualmente
      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];
        var storageRef = storage.ref().child('$prefix/imagem_$i.jpg');

        await storageRef.putFile(imageFile);
      }

      log('Imagens do espaço $spaceId enviadas com sucesso para o Firebase Storage');

      // todo: return?
      return Success(nil);
    } catch (e) {
      log('Erro ao enviar imagens para o Firebase Storage: $e');
      return Failure(RepositoryException(message: 'Erro ao salvar imagens'));
    }
  }

  @override
  Future<void> uploadSpaceVideos({
    required List<File> videoFiles,
    required String spaceId,
  }) async {
    try {
      // Crie um prefixo para os vídeos com base no espaçoId
      final prefix = 'espaços/$spaceId/videos';

      // Faça o upload de cada vídeo individualmente
      for (int i = 0; i < videoFiles.length; i++) {
        final videoFile = videoFiles[i];
        var storageRef = storage.ref().child('$prefix/video_$i.mp4');

        await storageRef.putFile(videoFile);
      }

      log('Vídeos do espaço $spaceId enviados com sucesso para o Firebase Storage');
    } catch (e) {
      log('Erro ao enviar vídeos para o Firebase Storage: $e');
    }
  }

  @override
  Future<List<String>> getSpaceVideos(String spaceId) async {
    try {
      // Crie um prefixo para os vídeos com base no spaceId
      final prefix = 'espaços/$spaceId/videos';

      // Recupere a lista de itens no Firebase Storage com o prefixo
      final ListResult result = await storage.ref().child(prefix).listAll();
      final videosUrl = <String>[];

      // Extraia as URLs dos vídeos da lista de itens
      for (var item in result.items) {
        final downloadURL = await item.getDownloadURL();
        videosUrl.add(downloadURL);
      }
      log('Vídeos do espaço $spaceId recuperados com sucesso do Firebase Storage');
      return videosUrl;
    } catch (e) {
      log('Erro ao recuperar vídeos do Firebase Storage: $e');
      throw Exception('Erro ao salvar vídeos');
    }
  }

  @override
  Future<Either<RepositoryException, List<String>>> getSpaceImages(
      String spaceId) async {
    try {
      // Crie um prefixo para as imagens com base no spaceId
      final prefix = 'espaços/$spaceId/images';

      // Recupere a lista de itens no Firebase Storage com o prefixo
      final ListResult result = await storage.ref().child(prefix).listAll();
      final imagesUrl = <String>[];

      // Extraia as URLs das imagens da lista de itens
      for (var item in result.items) {
        final downloadURL = await item.getDownloadURL();
        imagesUrl.add(downloadURL);
      }

      log('Imagens do espaço $spaceId recuperadas com sucesso do Firebase Storage');

      return Success(imagesUrl);
    } catch (e) {
      log('Erro ao recuperar imagens do Firebase Storage: $e');
      return Failure(RepositoryException(message: 'Erro ao recuperar imagens'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> uploadDocImages({
    required List<File> imageFiles,
    required String userId,
  }) async {
    try {
      final prefix = 'documentos/$userId';

      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];

        // Verifique se o arquivo existe antes de tentar fazer o upload
        if (imageFile.existsSync()) {
          var storageRef = storage.ref().child('$prefix/imagem_doc$i.jpg');
          await storageRef.putFile(imageFile);

          // Obtém a URL da imagem após o upload
          final imageUrl = await storageRef.getDownloadURL();

          // Atualiza o documento do usuário no Firestore
          QuerySnapshot querySnapshot =
              await usersCollection.where("uid", isEqualTo: userId).get();

          if (querySnapshot.docs.length == 1) {
            DocumentReference userDocRef = querySnapshot.docs[0].reference;

            await userDocRef.update({
              'doc${i + 1}_url': imageUrl,
            });

            log('Informações de usuário adicionadas com sucesso!');
          }
        } else {
          // Caso o arquivo não exista, lide com isso de acordo com a sua lógica
          log('Arquivo não encontrado: ${imageFile.path}');
          // Pode lançar uma exceção ou retornar um resultado de falha, dependendo do que você preferir
        }
      }

      log('Imagens do documento $userId enviadas com sucesso para o Firebase Storage e URLs salvas no Firestore');

      return Success(nil);
    } catch (e) {
      log('Erro ao enviar documentos para o Firebase Storage: $e');
      return Failure(RepositoryException(message: 'Erro ao salvar documento'));
    }
  }

  @override
  Future<Either<RepositoryException, List<String>>> getDocImages(
      String userId) async {
    try {
      // Crie um prefixo para as imagens com base no userId
      final prefix = 'documentos/$userId';

      // Recupere a lista de itens no Firebase Storage com o prefixo
      final ListResult result = await storage.ref().child(prefix).listAll();
      final imagesUrl = <String>[];

      // Extraia as URLs das imagens da lista de itens
      for (var item in result.items) {
        final downloadURL = await item.getDownloadURL();
        imagesUrl.add(downloadURL);
      }

      log('Imagens do documento do $userId recuperadas com sucesso do Firebase Storage');

      return Success(imagesUrl);
    } catch (e) {
      log('Erro ao recuperar documentos do Firebase Storage: $e');
      return Failure(
          RepositoryException(message: 'Erro ao recuperar documento'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> deleteDocImage({
    required String userId,
    required int imageIndex,
  }) async {
    try {
      final prefix = 'documentos/$userId';
      var storageRef = storage.ref().child('$prefix/imagem_doc$imageIndex.jpg');

      // Exclua a imagem no Firebase Storage
      await storageRef.delete();

      log('Imagem $imageIndex do documento $userId excluída com sucesso do Firebase Storage');

      return Success(nil);
    } catch (e) {
      log('Erro ao excluir imagem do Firebase Storage: $e');
      return Failure(RepositoryException(message: 'Erro ao excluir imagem'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> uploadAvatarImage({
    required File avatar,
    required String userId,
  }) async {
    try {
      final prefix = 'avatar/$userId';

      // Verifique se o arquivo existe antes de tentar fazer o upload
      if (avatar.existsSync()) {
        var storageRef = storage.ref().child('$prefix/imagem_avatar.jpg');
        await storageRef.putFile(avatar);

        // Obtém a URL da imagem após o upload
        final imageUrl = await storageRef.getDownloadURL();

        // Atualiza o documento do usuário no Firestore
        QuerySnapshot querySnapshot =
            await usersCollection.where("uid", isEqualTo: userId).get();

        if (querySnapshot.docs.length == 1) {
          DocumentReference userDocRef = querySnapshot.docs[0].reference;

          await userDocRef.update({
            'avatar_url': imageUrl,
          });

          log('Informações de usuário adicionadas com sucesso!');
        }
      } else {
        // Caso o arquivo não exista, lide com isso de acordo com a sua lógica
        log('Arquivo não encontrado: ${avatar.path}');
        // Pode lançar uma exceção ou retornar um resultado de falha, dependendo do que você preferir
      }

      log('Avatar do usuario $userId enviado com sucesso para o Firebase Storage');

      return Success(nil);
    } catch (e) {
      log('Erro ao enviar aavatar para o Firebase Storage: $e');
      return Failure(RepositoryException(message: 'Erro ao salvar avatar'));
    }
  }

  @override
  Future<Either<RepositoryException, List<String>>> getAvatarImage(
    String userId,
  ) async {
    try {
      // Crie um prefixo para as imagens com base no userId
      final prefix = 'avatar/$userId';

      // Recupere a referência da imagem no Firebase Storage
      final ListResult result = await storage.ref().child(prefix).listAll();
      final imagesUrl = <String>[];
      for (var item in result.items) {
        final downloadURL = await item.getDownloadURL();
        imagesUrl.add(downloadURL);
      }

      log('Imagem do avatar do $userId recuperada com sucesso do Firebase Storage');

      return Success(imagesUrl);
    } catch (e) {
      log('Erro ao recuperar imagem do avatar do Firebase Storage: $e');
      return Failure(
          RepositoryException(message: 'Erro ao recuperar imagem do avatar'));
    }
  }
}

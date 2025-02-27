import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final storage = FirebaseStorage.instance;

final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

Future<void> uploadSpaceImages(
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
  } catch (e) {
    log('Erro ao enviar imagens para o Firebase Storage: $e');
    throw Exception('Erro ao salvar imagens');
  }
}

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

Future<List<String>> getSpaceImages(String spaceId) async {
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

    return imagesUrl;
  } catch (e) {
    log('Erro ao recuperar imagens do Firebase Storage: $e');
    throw Exception('Erro ao recuperar imagens');
  }
}

Future<String?> uploadFile({
  required File file,
  required String spaceId,
}) async {
  try {
    final x = DateTime.now().millisecondsSinceEpoch.toString();
    var storageRef = FirebaseStorage.instance
        .ref()
        .child('espaços/$spaceId/images/imagem_$x.jpg');

    // Uploading the file
    UploadTask uploadTask = storageRef.putFile(
      file,
      SettableMetadata(
        contentType: 'image/jpeg',
      ),
    );

    // Await the completion of the upload
    await uploadTask;

    // Get the download URL
    String downloadURL = await storageRef.getDownloadURL();
    log('File uploaded successfully. Download URL: $downloadURL');
    return downloadURL;
  } catch (e) {
    log('Error uploading file: $e');
    return null;
  }
}

Future<String?> uploadVideoFile({
  required File file,
  required String spaceId,
}) async {
  try {
    final x = DateTime.now().millisecondsSinceEpoch.toString();
    var storageRef = FirebaseStorage.instance
        .ref()
        .child('spaços/$spaceId/videos/video_$x.mp4');

    // Uploading the file
    UploadTask uploadTask = storageRef.putFile(
      file,
    );

    // Await the completion of the upload
    await uploadTask;

    // Get the download URL
    String downloadURL = await storageRef.getDownloadURL();
    log('File uploaded successfully. Download URL: $downloadURL');
    return downloadURL;
  } catch (e) {
    log('Error uploading file: $e');
    return null;
  }
}

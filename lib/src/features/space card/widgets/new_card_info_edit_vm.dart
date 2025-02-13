import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewCardInfoEditVm {
  final String? spaceId;
  NewCardInfoEditVm({
    this.spaceId,
  });
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  Future<void> updateSpace({
    required Map<String, dynamic> newSpaceInfos,
    required List<String> networkImagesToDelete,
    required List<String> networkVideosToDelete,
    required List<File> imageFilesToDownload,
    required List<File> videosToDownload,
  }) async {
    QuerySnapshot querySnapshot = await spacesCollection
        .where(
          "space_id",
          isEqualTo: spaceId,
        )
        .get();

    if (querySnapshot.docs.length == 1) {
      DocumentReference spaceDocRef = querySnapshot.docs[0].reference;

      // Atualize o documento do usuário com os novos dados
      await spaceDocRef.update(newSpaceInfos);
      //todo: update latitude and longitude too

      log('Informações de usuário adicionadas com sucesso!');
    } else if (querySnapshot.docs.isEmpty) {
      // Nenhum documento com o userId especificado foi encontrado
      log('Usuário não encontrado no firestore.');
    }
  }
}

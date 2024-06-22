import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class NewCardInfoEditVm {
  final String? spaceId;
  NewCardInfoEditVm({
    this.spaceId,
  });
  final CollectionReference spacesCollection =
      FirebaseFirestore.instance.collection('spaces');

  Future<void> updateSpace(Map<String, dynamic> newSpaceInfos) async {
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

  void pickImage() async {
    final List<File> imageFiles = [];
    final imagePicker = ImagePicker();
    final List<XFile> images = await imagePicker.pickMultiImage();
    for (XFile image in images) {
      final imageFile = File(image.path);
      imageFiles.add(imageFile);
    }
  }

  Future<LatLng> calculateLatLng(
    String logradouro,
    String numero,
    String bairro,
    String cidade,
    String estado, // ou UF, dependendo da sua modelagem
  ) async {
    try {
      String fullAddress = '$logradouro, $numero, $bairro, $cidade, $estado';
      List<Location> locations = await locationFromAddress(fullAddress);

      if (locations.isNotEmpty) {
        return LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );
      } else {
        throw Exception(
            'Não foi possível obter as coordenadas para o endereço: $fullAddress');
      }
    } catch (e) {
      log('Erro ao calcular LatLng: $e');
      rethrow;
    }
  }
}

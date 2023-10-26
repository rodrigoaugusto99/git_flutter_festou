import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class VerFotos extends StatefulWidget {
  final SpaceModel space;
  const VerFotos({
    super.key,
    required this.space,
  });

  @override
  _VerFotosState createState() => _VerFotosState();
}

class _VerFotosState extends State<VerFotos> {
  final List<String> imageUrls = [];
  final storage = FirebaseStorage.instance;

  Future<void> loadAndDisplayImages() async {
    final spaceId = widget.space.spaceId;
    final imageUrls = await getSpaceImageUrls(spaceId);

    setState(() {
      this.imageUrls.clear();
      this.imageUrls.addAll(imageUrls);
    });
  }

  Future<List<String>> getSpaceImageUrls(String spaceId) async {
    try {
      final prefix = 'espaços/$spaceId';
      final storageRef = storage.ref().child(prefix);
      final items = await storageRef.listAll();
      final imageUrls = <String>[];

      for (var item in items.items) {
        final downloadURL = await item.getDownloadURL();
        imageUrls.add(downloadURL);
      }

      return imageUrls;
    } catch (e) {
      log('Erro ao obter URLs das imagens: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    loadAndDisplayImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar Imagens'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrls.isNotEmpty)
              Column(
                children: imageUrls
                    .map((imageUrl) => Image.network(imageUrl))
                    .toList(),
              )
            else
              const Text('Nenhuma imagem disponível'),
          ],
        ),
      ),
    );
  }
}

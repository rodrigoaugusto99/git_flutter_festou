import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class VerFotos extends StatefulWidget {
  const VerFotos({super.key, required SpaceModel space});

  @override
  _VerFotosState createState() => _VerFotosState();
}

class _VerFotosState extends State<VerFotos> {
  final List<String> _imageUrls = [];

  // Função para fazer o upload de imagens para o Firebase Storage
  Future<void> _uploadImages() async {
    final imagePicker = ImagePicker();
    final List<XFile> images = await imagePicker.pickMultiImage();

    for (XFile image in images) {
      final imageFile = File(image.path);
      try {
        // Nome do arquivo baseado na data e hora
        final imagePath = 'images/${DateTime.now()}.jpg';

        // Envia a imagem para o Firebase Storage
        await FirebaseStorage.instance.ref(imagePath).putFile(imageFile);

        // Recupera a URL da imagem do Firebase Storage
        final downloadURL =
            await FirebaseStorage.instance.ref(imagePath).getDownloadURL();

        setState(() {
          _imageUrls.add(downloadURL);
        });

        log('Imagem enviada com sucesso: $downloadURL');
      } catch (e) {
        log('Erro ao enviar a imagem: $e');
      }
    }
  }

  // Função para carregar imagens do Firebase Storage
  Future<void> _loadImages() async {
    // Aqui você pode fazer a lógica para carregar as imagens do Firebase Storage
    // usando as URLs armazenadas em _imageUrls.

    // Lembre-se de que, para carregar as imagens, você precisará de um widget, como
    // Image.network, para exibir as imagens a partir das URLs obtidas do Firebase Storage.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload de Imagem'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageUrls.isNotEmpty)
              Column(
                children: _imageUrls
                    .map((imageUrl) => Image.network(imageUrl))
                    .toList(),
              )
            else
              const Text('Nenhuma imagem selecionada'),
            ElevatedButton(
              onPressed: _uploadImages,
              child: const Text('Selecionar Imagem'),
            ),
            ElevatedButton(
              onPressed:
                  _loadImages, // Chame a função para carregar imagens aqui
              child: const Text('Carregar Imagens do Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}


/*1)beneficio de salvar localmente também:
-acesso rapido, desempenho, acesso offline

desvantagens:
-ocupará espaço no dispositivo(se for mta coisa, isso é ruim)
- sincronizaão, você precisa considerar como as imagens locais 
são sincronizadas com o Firebase ou qualquer outro servidor. 
Se os usuários fizerem alterações em suas imagens locais, 
você deve lidar com a sincronização de dados para 
manter a versão no Firebase atualizada.

2) Sobre o imagePath:
-É uma string que define o nome do arquivo e a 
localização da imagem no armazenamento em nuvem.
-Você está criando uma string imagePath que começa 
com "images/" e depois concatena com a data e hora 
atual formatada como uma string, seguida de ".jpg". 
Isso cria um nome de arquivo único com base no carimbo 
de data e hora atual, o que é útil para garantir que 
os nomes de arquivo sejam exclusivos e não se sobrescrevam.
-Você está dizendo ao Firebase Storage para armazenar o 
arquivo no caminho especificado, que inclui o nome 
exclusivo gerado pela data e hora.*/

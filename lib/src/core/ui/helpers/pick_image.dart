import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  final List<File> _imageFiles = [];
  final List<String> _imageUrls = [];
  Future<void> _uploadImages() async {
    final imagePicker = ImagePicker();
    final List<XFile> images = await imagePicker.pickMultiImage();

    //final imagePath = 'images/${DateTime.now()}.jpg';

    for (XFile image in images) {
      final imageFile = File(image.path);
      try {
        //jogar no firebase
        /*await firebase_storage.FirebaseStorage.instance
  .ref(imagePath)
  .putFile(imageFile);

  //recuperar do firebase
  final downloadURL = await firebase_storage.FirebaseStorage.instance
  .ref(imagePath)
  .getDownloadURL();*/

        setState(() {
          _imageFiles.add(imageFile);
          //_imageUrl = downloadURL;
        });

        log('Imagem enviada com sucesso: $_imageUrls');
      } catch (e) {
        log('Erro ao enviar a imagem: $e');
      }
    }
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
            if (_imageFiles.isNotEmpty)
              Column(
                children: _imageFiles
                    .map((imageFile) => Image.file(imageFile))
                    .toList(),
              )
            else
              const Text('Nenhuma imagem selecionada'),
            ElevatedButton(
              onPressed: _uploadImages,
              child: const Text('Selecionar Imagem'),
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
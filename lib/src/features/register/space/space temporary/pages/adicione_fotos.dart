import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/titulo.dart';
import 'package:video_player/video_player.dart';

class AdicioneFotos extends ConsumerStatefulWidget {
  const AdicioneFotos({super.key});

  @override
  ConsumerState<AdicioneFotos> createState() => _AdicioneFotosState();
}

class _AdicioneFotosState extends ConsumerState<AdicioneFotos> {
  final List<VideoPlayerController> localControllers = [];

  int photosLength = 0;
  int? selectedPhotoIndex;

  @override
  Widget build(BuildContext context) {
    final spaceRegister = ref.watch(newSpaceRegisterVmProvider.notifier);

    Widget customGrid({
      required List<File> imageFiles,
      required VoidCallback onAddPressed,
      required Function(int index) onDelete,
    }) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 itens por linha
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount:
            imageFiles.length + 1, // Adiciona espaço para o botão de adicionar
        itemBuilder: (context, index) {
          if (index < imageFiles.length) {
            // Exibe a imagem se for um item da lista
            return GestureDetector(
              onTap: () {
                selectedPhotoIndex = index;
                setState(() {});
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: selectedPhotoIndex == index
                            ? Colors.black.withOpacity(0.5) // Fundo preto opaco
                            : Colors.transparent,
                      ),
                      child: Image.file(
                        imageFiles[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    if (selectedPhotoIndex == index)
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black
                                .withOpacity(0.5) // Fundo preto opaco

                            ),
                      ),
                    if (selectedPhotoIndex == index)
                      Positioned(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              // Aqui você pode implementar a lógica para excluir a imagem
                              onDelete(index);
                            });
                          },
                          child: Image.asset(
                            'lib/assets/images/Ellipse 37lixeira-foto.png',
                            width: 40,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          } else {
            // Exibe o botão de adicionar no último slot
            return GestureDetector(
              onTap: onAddPressed,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // Arredonda as bordas
                child: GestureDetector(
                  onTap: () async {
                    await spaceRegister.pickImage();
                    setState(() {});
                  },
                  child: Image.asset(
                    'lib/assets/images/Botao +botao_de_mais.png',
                    width: 25,
                  ),
                ),
              ),
            );
          }
        },
        padding: const EdgeInsets.all(8.0),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8F8F8),
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Container(
            decoration: BoxDecoration(
              //color: Colors.white.withOpacity(0.7),
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Cadastro de espaço',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Adicione algumas fotos e vídeos do seu espaço:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xff4300B1),
                ),
              ),
              const SizedBox(
                height: 19,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 27),
                child: Text(
                  'Você precisa de pelo menos cinco fotos para começar. Você pode adicionar outras imagens ou vídeos ou fazer alterações mais tarde.',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              customGrid(
                onDelete: (index) {
                  spaceRegister.imageFiles.removeAt(index);
                },
                imageFiles: spaceRegister.imageFiles,
                onAddPressed: () async {
                  photosLength = await spaceRegister.pickImage();
                  setState(() {});
                },
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 9),
                      alignment: Alignment.center,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff9747FF),
                            Color(0xff44300b1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: const Text(
                        'Voltar',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (spaceRegister.imageFiles.isEmpty) {
                        Messages.showInfo(
                            'Adicione pelo menos uma foto', context);
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Titulo(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 9),
                      alignment: Alignment.center,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff9747FF),
                            Color(0xff44300b1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: const Text(
                        'Avançar',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     photosLength = await spaceRegister.pickImage();
              //     setState(() {});
              //   },
              //   child: const Text('Adicionar fotos'),
              // ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

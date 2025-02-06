import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/titulo.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/utils.dart';
import 'package:git_flutter_festou/src/helpers/keys.dart';
import 'package:video_player/video_player.dart';

class AdicioneFotos extends ConsumerStatefulWidget {
  const AdicioneFotos({super.key});

  @override
  ConsumerState<AdicioneFotos> createState() => _AdicioneFotosState();
}

class _AdicioneFotosState extends ConsumerState<AdicioneFotos> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // final vm = ref.read(newSpaceRegisterVmProvider.notifier);
    // final state = vm.getState();
    // selectedTypes = state.selectedTypes;
    // Cria um Timer que atualiza o estado a cada 5 segundos
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        // Atualize qualquer estado necessário aqui
        print("setState chamado");
      });
    });
  }

  @override
  void dispose() {
    // Cancele o timer ao descartar o widget para evitar problemas
    _timer?.cancel();
    super.dispose();
  }

  int photosLength = 0;
  int? selectedPhotoIndex;
  int? selectedVideoIndex;

  @override
  Widget build(BuildContext context) {
    final spaceRegister = ref.watch(newSpaceRegisterVmProvider.notifier);

    Widget customVideoGrid({
      required List<File> videoFiles,
      required VoidCallback onAddPressed,
      required List<VideoPlayerController> controllers,
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
            videoFiles.length + 1, // Adiciona espaço para o botão de adicionar
        itemBuilder: (context, index) {
          if (index < videoFiles.length) {
            // Exibe a imagem se for um item da lista
            return GestureDetector(
              onTap: () {
                selectedVideoIndex = index;
                setState(() {});
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: selectedVideoIndex == index
                            ? Colors.black.withOpacity(0.5) // Fundo preto opaco
                            : Colors.transparent,
                      ),
                      child: AbsorbPointer(
                          child: buildVideoPlayerFromFile(
                              index, context, controllers)),
                    ),
                    if (selectedVideoIndex == index)
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black
                                .withOpacity(0.5) // Fundo preto opaco

                            ),
                      ),
                    if (selectedVideoIndex == index)
                      Positioned(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              // Aqui você pode implementar a lógica para excluir a imagem
                              onDelete(index);
                            });
                          },
                          child: Image.asset(
                            'lib/assets/images/icon_lixeira.png',
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
              child: Image.asset(
                'lib/assets/images/imagem_mais.png',
                scale: 1.5,
              ),
            );
          }
        },
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
      );
    }

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
                            'lib/assets/images/icon_lixeira.png',
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
              child: Image.asset(
                'lib/assets/images/imagem_mais.png',
                scale: 1.5,
              ),
            );
          }
        },
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '(${spaceRegister.imageFiles.length} fotos)',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: Color(0xff5E5E5E),
                      ),
                    ),
                  ],
                  text: 'Fotos ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
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
              const SizedBox(
                height: 45,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '(${spaceRegister.imageFiles.length} vídeos)',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: Color(0xff5E5E5E),
                      ),
                    ),
                  ],
                  text: 'Vídeos ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              customVideoGrid(
                onDelete: (index) {
                  spaceRegister.videos.removeAt(index);
                  spaceRegister.localControllers.removeAt(index);
                  setState(() {});
                },
                videoFiles: spaceRegister.videos,
                onAddPressed: () async {
                  await spaceRegister.pickVideo();
                  // await Future.delayed(const Duration(seconds: 1));
                  setState(() {});
                },
                controllers: spaceRegister.localControllers,
              ),
              const SizedBox(
                height: 50,
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
                    key: Keys.k5creenButton,
                    onTap: () {
                      // if (spaceRegister.imageFiles.isEmpty) {
                      //   Messages.showInfo(
                      //       'Adicione pelo menos uma foto', context);
                      //   return;
                      // }

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

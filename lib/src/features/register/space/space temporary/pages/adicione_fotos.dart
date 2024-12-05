import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/textfield.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/titulo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AdicioneFotos extends ConsumerStatefulWidget {
  const AdicioneFotos({super.key});

  @override
  ConsumerState<AdicioneFotos> createState() => _AdicioneFotosState();
}

class _AdicioneFotosState extends ConsumerState<AdicioneFotos> {
  final List<VideoPlayerController> localControllers = [];

  // void pickVideo() async {
  //   final videoPicker = ImagePicker();
  //   final XFile? video =
  //       await videoPicker.pickVideo(source: ImageSource.gallery);

  //   if (video != null) {
  //     int currentTotalVideos =
  //         widget.space.videosUrl.length + videosToDownload.length;
  //     int remainingSlots = 3 - currentTotalVideos;

  //     if (remainingSlots > 0) {
  //       final videoFile = File(video.path);
  //       setState(() {
  //         videosToDownload.add(videoFile);
  //         VideoPlayerController controller =
  //             VideoPlayerController.file(videoFile)
  //               ..initialize().then((_) {
  //                 setState(() {});
  //               });
  //         localControllers.add(controller);
  //       });
  //     }
  //   }
  // }

  // Widget mySecondWidget() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         children: [
  //           const Text(
  //             'Fotos ',
  //             style: TextStyle(
  //               fontWeight: FontWeight.w700,
  //               fontSize: 14,
  //             ),
  //           ),
  //           Text(
  //             '(${widget.space.imagesUrl.length} ${widget.space.imagesUrl.length == 1 ? 'foto)' : 'fotos)'}',
  //             style: const TextStyle(
  //               fontWeight: FontWeight.w400,
  //               fontSize: 12,
  //               color: Color(0xff5E5E5E),
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 13),
  //       GridView.builder(
  //         padding: EdgeInsets.zero,
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //           mainAxisSpacing: 13,
  //           crossAxisSpacing: 13,
  //           crossAxisCount: 3,
  //         ),
  //         itemCount: 6, // Sempre terá 6 itens no grid
  //         itemBuilder: (BuildContext context, int index) {
  //           int networkImagesCount = widget.space.imagesUrl.length;
  //           int localImagesCount = imageFilesToDownload.length;
  //           int totalImagesCount = networkImagesCount + localImagesCount;
  //           int maxImages = 6;

  //           if (index < networkImagesCount) {
  //             // Mostrar as imagens da lista de URLs
  //             return ClipRRect(
  //               borderRadius: BorderRadius.circular(10),
  //               child: Stack(
  //                 alignment: Alignment.center,
  //                 children: [
  //                   ClipRRect(
  //                     borderRadius: BorderRadius.circular(10),
  //                     child: Image.network(
  //                       height: 90,
  //                       widget.space.imagesUrl[index].toString(),
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                   if (isEditing)
  //                     decContainer(
  //                       color: Colors.black.withOpacity(0.5),
  //                     ),
  //                   if (isEditing)
  //                     GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           networkImagesToDelete
  //                               .add(widget.space.imagesUrl[index].toString());
  //                           widget.space.imagesUrl.removeAt(index);
  //                         });
  //                       },
  //                       child: Image.asset(
  //                         'lib/assets/images/Ellipse 37lixeira-foto.png',
  //                         width: 40,
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             );
  //           } else if (index < networkImagesCount + localImagesCount) {
  //             // Mostrar as imagens da lista de arquivos locais
  //             int localIndex = index - networkImagesCount;
  //             return ClipRRect(
  //               borderRadius: BorderRadius.circular(10),
  //               child: Stack(
  //                 alignment: Alignment.center,
  //                 children: [
  //                   Image.file(
  //                     imageFilesToDownload[localIndex],
  //                     fit: BoxFit.cover,
  //                   ),
  //                   if (isEditing)
  //                     decContainer(
  //                       color: Colors.black.withOpacity(0.5),
  //                     ),
  //                   if (isEditing)
  //                     GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           imageFilesToDownload.removeAt(localIndex);
  //                         });
  //                       },
  //                       child: Image.asset(
  //                         'lib/assets/images/Ellipse 37lixeira-foto.png',
  //                         width: 40,
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             );
  //           } else if (index == totalImagesCount &&
  //               totalImagesCount < maxImages) {
  //             // Mostrar a imagem do asset se estiver no próximo índice após a última imagem da lista
  //             if (isEditing) {
  //               return GestureDetector(
  //                 onTap: pickImage,
  //                 child: Image.asset(
  //                   'lib/assets/images/Botao +botao_de_mais.png',
  //                   width: 25,
  //                 ),
  //               );
  //             } else {
  //               return null;
  //             }
  //           } else {
  //             return null;
  //           }
  //         },
  //       ),
  //       const SizedBox(height: 26),
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         children: [
  //           const Text(
  //             'Vídeos ',
  //             style: TextStyle(
  //               fontWeight: FontWeight.w700,
  //               fontSize: 14,
  //             ),
  //           ),
  //           Text(
  //             '(${widget.space.videosUrl.length} ${widget.space.videosUrl.length == 1 ? 'vídeo' : 'vídeos)'}',
  //             style: const TextStyle(
  //               fontWeight: FontWeight.w400,
  //               fontSize: 12,
  //               color: Color(0xff5E5E5E),
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 13),
  //       GridView.builder(
  //         padding: EdgeInsets.zero,
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //           mainAxisSpacing: 13,
  //           crossAxisSpacing: 13,
  //           crossAxisCount: 3,
  //         ),
  //         itemCount: 3, // Sempre terá 3 itens no grid
  //         itemBuilder: (BuildContext context, int index) {
  //           int networkVideosCount = widget.space.videosUrl.length;
  //           int localVideosCount =
  //               videosToDownload.length > 3 ? 3 : videosToDownload.length;
  //           int totalVideosCount = networkVideosCount + localVideosCount;
  //           int maxVideos = 3;

  //           if (index < networkVideosCount) {
  //             // Mostrar os vídeos da lista de URLs
  //             return ClipRRect(
  //               borderRadius: BorderRadius.circular(10),
  //               child: Stack(
  //                 alignment: Alignment.center,
  //                 children: [
  //                   buildVideoPlayer(index),
  //                   if (isEditing)
  //                     Container(
  //                       color: Colors.black.withOpacity(0.5),
  //                     ),
  //                   if (isEditing)
  //                     GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           networkVideosToDelete
  //                               .add(widget.space.videosUrl[index]);
  //                           widget.space.videosUrl.removeAt(index);
  //                           controllers[index].dispose();
  //                           controllers.removeAt(index);
  //                         });
  //                       },
  //                       child: Image.asset(
  //                         'lib/assets/images/Ellipse 37lixeira-foto.png',
  //                         width: 40,
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             );
  //           } else if (index < networkVideosCount + localVideosCount) {
  //             // Mostrar os vídeos da lista de arquivos locais
  //             int localIndex = index - networkVideosCount;
  //             return ClipRRect(
  //               borderRadius: BorderRadius.circular(10),
  //               child: Stack(
  //                 alignment: Alignment.center,
  //                 children: [
  //                   buildVideoPlayerFromFile(localIndex),
  //                   if (isEditing)
  //                     Container(
  //                       color: Colors.black.withOpacity(0.5),
  //                     ),
  //                   if (isEditing)
  //                     GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           videosToDownload.removeAt(localIndex);
  //                           localControllers[localIndex].dispose();
  //                           localControllers.removeAt(localIndex);
  //                         });
  //                       },
  //                       child: Image.asset(
  //                         'lib/assets/images/Ellipse 37lixeira-foto.png',
  //                         width: 40,
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             );
  //           } else if (index == totalVideosCount &&
  //               totalVideosCount < maxVideos) {
  //             // Mostrar a imagem do asset se estiver no próximo índice após o último vídeo da lista
  //             if (isEditing) {
  //               return GestureDetector(
  //                 onTap: pickVideo,
  //                 child: Image.asset(
  //                   'lib/assets/images/Botao +botao_de_mais.png',
  //                   width: 25,
  //                 ),
  //               );
  //             } else {
  //               return null;
  //             }
  //           } else {
  //             return null;
  //           }
  //         },
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final spaceRegister = ref.watch(newSpaceRegisterVmProvider.notifier);
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
        child: Column(
          children: [
            Column(
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
                ElevatedButton(
                    onPressed: () => spaceRegister.pickImage(),
                    child: const Text('Adicionar fotos')),
                ElevatedButton(
                    onPressed: () {}, child: const Text('Tirar novas fotos')),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 69, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Titulo(),
                ),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
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
      ),
    );
    return Scaffold(
      appBar: AppBar(
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
          'Cadastrar',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adicione algumas fotos e vídeos do seu espaço:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xff4300B1),
                  ),
                ),
                SizedBox(
                  height: 19,
                ),
                Text(
                  'Você precisa de pelo menos cinco fotos para começar. Você pode adicionar outras imagens ou vídeos ou fazer alterações mais tarde.',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
                onPressed: () => spaceRegister.pickImage(),
                child: const Text('Adicionar fotos')),
            ElevatedButton(
                onPressed: () {}, child: const Text('Tirar novas fotos')),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Voltar',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Titulo(),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: const Text(
                        'Avançar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

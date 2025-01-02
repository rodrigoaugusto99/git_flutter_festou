import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/helpers/keys.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image_painter/image_painter.dart';

class SignatureDialog extends StatefulWidget {
  const SignatureDialog({super.key});

  @override
  State<SignatureDialog> createState() => _SignatureDialogState();
}

class _SignatureDialogState extends State<SignatureDialog> {
  GlobalKey<ImagePainterState> imageKey = GlobalKey<ImagePainterState>();
  ImagePainterController? imagePainterController;
  Uint8List? signedImageBytes;

  @override
  void initState() {
    super.initState();
    imagePainterController = ImagePainterController();
  }

  void onSign() async {
    if (imagePainterController != null) {
      final Uint8List? signedImageBytes =
          await imagePainterController!.exportImage();

      if (signedImageBytes != null) {
        if (imageKey.currentState?.isEdited ?? false) {
          final ByteData data = ByteData.sublistView(signedImageBytes);
          final Uint8List uint8List =
              Uint8List.fromList(data.buffer.asUint8List());

          final ui.Codec codec = await ui.instantiateImageCodec(uint8List);
          final ui.FrameInfo frameInfo = await codec.getNextFrame();
          final ui.Image signedImage = frameInfo.image;
          //await Future.delayed(const Duration(seconds: 2));
          log(signedImage.toString(), name: 'signeeed');
          Navigator.of(context).pop(signedImage);

          //await navToImageTerms(signedImage);
        } else {
          //todo:
          print('The user did not draw anything.');
        }
      }
    }
  }

  // @override
  // void dispose() {
  //   imagePainterController!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Assinar"),
      content: Stack(
        key: Keys.kSignaturePaper,
        children: [
          ImagePainter.asset(
            'lib/assets/images/dsszz.png',
            key: imageKey,
            controller: imagePainterController!,
            selectedColor: Colors.black,
            showControls: false,
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
                onTap: () {
                  imagePainterController!.clear();
                },
                child: const Icon(Icons.undo)),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () async {
            onSign();
          },
          child: const Text("Confirmar"),
        ),
      ],
    );
  }
}

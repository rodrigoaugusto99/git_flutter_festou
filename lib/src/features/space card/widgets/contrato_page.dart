import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/contrato_assinado_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/signature_dialog.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/summary_data.dart';
import 'package:git_flutter_festou/src/models/cupom_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class ContratoPage extends StatefulWidget {
  final SummaryData summaryData;
  final CupomModel? cupomModel;
  String? html;
  ContratoPage({
    super.key,
    required this.summaryData,
    required this.cupomModel,
    required this.html,
  });

  @override
  State<ContratoPage> createState() => _ContratoPageState();
}

class _ContratoPageState extends State<ContratoPage> {
  Future replaceMarkers(
      {
      // required String cpf,
      // required String name,
      required ui.Image image}) async {
    String modifiedHtml = widget.html!;

    String base64Image = '';
    base64Image = await imageToBase64(image);
    log(base64Image);
    modifiedHtml = modifiedHtml.replaceAll('[Assinatura do cliente]',
        '<img src="$base64Image" alt="Descrição da imagem"/>');

    widget.html = modifiedHtml;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ContratoAssinadoPage(
          summaryData: widget.summaryData,
          cupomModel: widget.cupomModel,
          html: widget.html,
        ),
      ),
    );
  }

  Future<String> imageToBase64(ui.Image image) async {
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();
    final String base64String = base64Encode(uint8List);

    return 'data:image/png;base64,$base64String';
  }

  @override
  Widget build(BuildContext context) {
    ui.Image? signature;
    return Scaffold(
      backgroundColor: Colors.white,
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
                  offset: const Offset(0, 2), // changes position of shadow
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
          'Contrato',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: SingleChildScrollView(
          child: Html(
            data: widget.html,
            style: {
              'body': Style(
                fontSize: FontSize(12.0),
              ),
              'p': Style(
                margin: Margins.only(
                  bottom: 8,
                ),
              ),
              'h2': Style(
                color: const Color(0xff304571),
                margin: Margins.only(
                  bottom: 0,
                ),
              ),
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.purple, // Cor do botão
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Bordas arredondadas
                ),
              ),
              onPressed: () async {
                final response = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignatureDialog(),
                  ),
                );
                //log(response, name: 'response');

                if (response != null && response is ui.Image) {
                  setState(() {
                    signature = response;
                  });
                  replaceMarkers(
                    image: signature!,
                  );
                  log('Signature captured', name: 'response');
                } else {
                  log('No signature captured', name: 'response');
                }
              },
              child: const Text('Assinar contrato'),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.purple, // Cor do botão
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Bordas arredondadas
                ),
              ),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ResumoReservaPage(
                //       spaceModel: widget.spaceModel,
                //     ),
                //   ),
                // );
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}

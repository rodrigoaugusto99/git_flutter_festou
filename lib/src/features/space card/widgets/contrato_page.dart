import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/contrato_assinado_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/signature_dialog.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/summary_data.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class ContratoPage extends StatefulWidget {
  final SummaryData summaryData;

  const ContratoPage({
    super.key,
    required this.summaryData,
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
    String modifiedHtml = widget.summaryData.html;

//todo: replace all markers
    modifiedHtml = modifiedHtml.replaceAll('{Data de Início do Evento}',
        '<b>${widget.summaryData.checkInTime}</b>');

    modifiedHtml = modifiedHtml.replaceAll('{Data de Término do Evento}',
        '<b>${widget.summaryData.checkOutTime}</b>');
    // modifiedHtml = modifiedHtml.replaceAll('{name}', '<b>$name</b>');
    // modifiedHtml = modifiedHtml.replaceAll('{name}', '<b>$name</b>');
    // modifiedHtml = modifiedHtml.replaceAll('{name}', '<b>$name</b>');

    String base64Image = '';
    base64Image = await imageToBase64(image);
    modifiedHtml += '<img src="$base64Image" alt="Descrição da imagem"/>';
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ContratoAssinadoPage(
          summaryData: widget.summaryData,
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
          'Calendário',
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
            data: widget.summaryData.html,
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

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Festou/src/core/ui/constants.dart';
import 'package:Festou/src/core/ui/helpers/messages.dart';
import 'package:Festou/src/features/login/forgot_email_page.dart';
import 'package:Festou/src/features/space%20card/widgets/signature_dialog.dart';
import 'package:Festou/src/features/widgets/custom_textformfield.dart';
import 'package:Festou/src/helpers/keys.dart';
import 'package:Festou/src/services/user_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validatorless/validatorless.dart';

class RegisterSignature extends StatefulWidget {
  const RegisterSignature({super.key});

  @override
  State<RegisterSignature> createState() => _RegisterSignatureState();
}

class _RegisterSignatureState extends State<RegisterSignature> {
  final cpfEC = TextEditingController();
  final nomeEmpresaLocadoraEC = TextEditingController();
  final cnpjEmpresaLocadoraEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  ui.Image? signature;
  String? signatureString;
  Future<String> imageToBase64(ui.Image image) async {
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();
    final String base64String = base64Encode(uint8List);

    return 'data:image/png;base64,$base64String';
  }

  Future<void> updateLocadorInfos({
    required String cpf,
    required String cnpj,
    required String empresaName,
    required String assinatura,
  }) async {
    try {
      final user = await UserService().getCurrentUserModel();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("uid", isEqualTo: user!.uid)
          .get();

      if (querySnapshot.docs.length == 1) {
        DocumentReference userDocRef = querySnapshot.docs[0].reference;
        Map<String, dynamic> newInfo = {
          'cpf': cpf,
          'cnpj': cnpj,
          'fantasy_name': empresaName,
          'assinatura': assinatura,
        };

        // Atualize o documento do usuário com os novos dados
        await userDocRef.update(newInfo);

        log('Informações de usuário adicionadas com sucesso!');
      } else if (querySnapshot.docs.isEmpty) {
        // Nenhum documento com o userId especificado foi encontrado
        log('Usuário não encontrado no firestore.');
        throw Exception('Usuário não encontrado no banco de dados.');
      } else {
        // Mais de um documento com o mesmo userId foi encontrado (situação incomum)
        throw Exception('Conflito de dados no bando de dados.');
      }
    } catch (e) {
      log('Erro ao adicionar informações de usuário no firestore: $e');
      throw Exception('Erro ao atualizar informações de usuário.');
    }
  }

  var cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  var cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double firstContainer = (179 / 732) * screenHeight;
    final double buttonWidth = (260 / 412) * screenWidth;
    final double buttonHeight = (37 / 732) * screenHeight;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      resizeToAvoidBottomInset: true,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                height: firstContainer,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      height: firstContainer,
                      child: Image.asset(
                        ImageConstants.serpentinae,
                      ),
                    ),
                    Align(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [
                                  Color(0xff9747FF),
                                  Color(0xff5B2B99),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(
                                Rect.fromLTWH(
                                  0,
                                  0,
                                  bounds.width,
                                  bounds.height,
                                ),
                              );
                            },
                            child: const Text(
                              'FESTOU',
                              style: TextStyle(
                                fontFamily: 'NerkoOne',
                                fontSize: 50,
                                height: 0.8,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 15.0,
                                    color: Color.fromARGB(75, 0, 0, 0),
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Locador',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                height: 1,
                                fontFamily: 'Marcellus',
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      height: firstContainer,
                      child: Image.asset(
                        ImageConstants.serpentinad,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextformfield(
                      label: 'CPF',
                      controller: cpfEC,
                      inputFormatters: [cpfFormatter],
                      validator: Validatorless.required('Campo obrigatório'),
                    ),
                    const SizedBox(height: 10),
                    CustomTextformfield(
                      label: 'Nome da empresa',
                      controller: nomeEmpresaLocadoraEC,
                      validator: Validatorless.required('Campo obrigatório'),
                    ),
                    const SizedBox(height: 10),
                    CustomTextformfield(
                      label: 'CNPJ da empresa',
                      controller: cnpjEmpresaLocadoraEC,
                      inputFormatters: [cnpjFormatter],
                      validator: Validatorless.required('Campo obrigatório'),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      key: Keys.kSignaturePaint,
                      onTap: () async {
                        final response = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignatureDialog(),
                          ),
                        );
                        if (response != null && response is ui.Image) {
                          setState(() {
                            signature = response;
                          });

                          log('Signature captured', name: 'response');
                        } else {
                          log('No signature captured', name: 'response');
                        }
                      },
                      child: signature == null
                          ? GestureDetector(
                              onTap: () async {
                                final response = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SignatureDialog(),
                                  ),
                                );
                                if (response != null && response is ui.Image) {
                                  setState(() {
                                    signature = response;
                                  });
                                  signatureString =
                                      await imageToBase64(signature!);
                                  log('Signature captured', name: 'response');
                                } else {
                                  log('No signature captured',
                                      name: 'response');
                                }
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
                                  'Registrar minha assinatura',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: CustomPaint(
                                size: const Size(
                                    200, 100), // Tamanho da assinatura
                                painter: SignaturePainter(signature!),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 75, left: 75, bottom: 90),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              key: Keys.kLocadorFormEnviarButton,
              onTap: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                if (signatureString == null) {
                  Messages.showInfo('Registre sua assinatura', context);
                  return;
                }
                try {
                  await updateLocadorInfos(
                    cpf: cpfEC.text,
                    cnpj: cnpjEmpresaLocadoraEC.text,
                    empresaName: nomeEmpresaLocadoraEC.text,
                    assinatura: signatureString!,
                  );
                  Navigator.of(context).pop(true);
                } on Exception catch (e) {
                  log(e.toString());
                  Navigator.of(context).pop(false);
                }
              },
              child: Container(
                alignment: Alignment.center,
                width: buttonWidth,
                height: buttonHeight,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff9747FF),
                      Color(0xff4300B1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'ENVIAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                alignment: Alignment.center,
                width: buttonWidth,
                height: buttonHeight,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff9747FF),
                      Color(0xff4300B1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'VOLTAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final ui.Image signature;

  SignaturePainter(this.signature);

  @override
  void paint(Canvas canvas, Size size) {
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.width, size.height),
      image: signature,
      fit: BoxFit.contain,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ForgotEmailPage extends StatefulWidget {
  const ForgotEmailPage({Key? key}) : super(key: key);

  @override
  State<ForgotEmailPage> createState() => _ForgotEmailPageState();
}

class _ForgotEmailPageState extends State<ForgotEmailPage> {
  final cpfCnpjEC = TextEditingController();
  MaskTextInputFormatter mask = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void dispose() {
    cpfCnpjEC.dispose();
    super.dispose();
  }

  String formatCPF(String value) {
    return '${value.substring(0, 3)}.${value.substring(3, 6)}.${value.substring(6, 9)}-${value.substring(9, 11)}';
  }

  String formatCNPJ(String value) {
    return '${value.substring(0, 2)}.${value.substring(2, 5)}.${value.substring(5, 8)}/${value.substring(8, 12)}-${value.substring(12, 14)}';
  }

  int getNumericLength(String text) {
    // Filtra apenas os caracteres numéricos
    String numericText = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Retorna o comprimento dos caracteres numéricos
    return numericText.length;
  }

  String? meuEmail;

  List<String> errors = [
    'erro - documento invalido',
    'erro - nao encontrado',
    'erro'
  ];

  String removeSpecialCharacters(String text) {
    return text.replaceAll(
        RegExp(r'[^0-9]'), ''); // Remove tudo que não for número
  }

  Future<String?> findEmailByCPFOrCNPJ(String cpfCnpj) async {
    if (cpfCnpj.length != 11) {
      return errors[0];
    }

    try {
      // Consulte a coleção para encontrar documentos com o campo "cpf" correspondente
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('cpf', isEqualTo: cpfCnpj)
          .get();

      // Verifique se há documentos correspondentes
      if (querySnapshot.docs.isNotEmpty) {
        // Obtenha o primeiro documento correspondente
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        // Obtenha o valor do campo "email" e retorne
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        String? email = data['email'];
        return email;
      } else {
        // Documento não encontrado
        log('Documento com CPF/CNPJ $cpfCnpj não encontrado.');
        return errors[1];
      }
    } catch (e) {
      // Trate erros durante a busca
      log('Erro ao buscar documento: $e');
      return errors[2];
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double firstContainer = (179 / 732) * screenHeight;
    final double voltarButtonWidth = (202 / 412) * screenWidth;
    final double voltarButtonHeight = (37 / 732) * screenHeight;
    final double consultarButtonWidth = (74 / 412) * screenWidth;
    final double consultarButtonHeight = (30 / 732) * screenHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Column(
            children: [
              SizedBox(
                height: firstContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      ImageConstants.serpentinae,
                    ),
                    const Text('recuperar\nconta'),
                    Image.asset(
                      ImageConstants.serpentinad,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 450,
                        left: 10,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CPF/CNPJ:',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            TextFormField(
                              controller: cpfCnpjEC,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                int numericLength = getNumericLength(value);

                                if (numericLength == 11) {
                                  setState(() {
                                    cpfCnpjEC.text = formatCPF(value.replaceAll(
                                        RegExp(r'[^0-9]'), ''));
                                  });
                                } else if (numericLength == 14) {
                                  setState(() {
                                    cpfCnpjEC.text = formatCNPJ(value
                                        .replaceAll(RegExp(r'[^0-9]'), ''));
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 2.0),
                                hintText: 'Digite aqui seu documento',
                                hintStyle:
                                    TextStyle(color: Colors.black, fontSize: 9),
                                //border: InputBorder.none,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                ),
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                isDense: true,
                              ),
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 380,
                        child: InkWell(
                          onTap: () async {
                            meuEmail = await findEmailByCPFOrCNPJ(
                                removeSpecialCharacters(cpfCnpjEC.text));
                            /*fica aqui fora pois como o findEmailByCpf eh assincrona,
                            precisa esperar, coisa que o setState nao faz.*/
                            setState(() {});
                            if (meuEmail == errors[0]) {
                              Messages.showError(
                                  'Formato de CPF ou CNPJ inválido', context);
                            } else if (meuEmail == errors[1]) {
                              Messages.showError(
                                  'Não há um e-mail com esse CPF/CNPJ cadastrado',
                                  context);
                            } else if (meuEmail == errors[2]) {
                              Messages.showError(
                                  'Erro ao buscar e-mail', context);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: consultarButtonWidth + 10,
                            height: consultarButtonHeight,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 13, 46, 89),
                              borderRadius: BorderRadius.circular(
                                  50), // Borda arredondada
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Consultar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      meuEmail != null && !errors.contains(meuEmail)
                          ? Positioned(
                              bottom: 230,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  const Text('Seu e-mail é:'),
                                  Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.red)),
                                      child: Text(meuEmail!)),
                                ],
                              ),
                            )
                          : Container(),
                      Positioned(
                        bottom: 70,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            alignment: Alignment.center,
                            width: voltarButtonWidth,
                            height: voltarButtonHeight,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 13, 46, 89),
                              borderRadius: BorderRadius.circular(
                                  10), // Borda arredondada
                            ),
                            child: const Text(
                              'VOLTAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

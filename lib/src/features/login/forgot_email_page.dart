import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';

class ForgotEmailPage extends StatefulWidget {
  const ForgotEmailPage({Key? key}) : super(key: key);

  @override
  State<ForgotEmailPage> createState() => _ForgotEmailPageState();
}

class _ForgotEmailPageState extends State<ForgotEmailPage> {
  final cpfCnpjEC = TextEditingController();
  @override
  void dispose() {
    cpfCnpjEC.dispose();
    super.dispose();
  }

  String? meuEmail;

  Future<String?> findEmailByCPF(String cpf) async {
    try {
      // Consulte a coleção para encontrar documentos com o campo "cpf" correspondente
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('cpf', isEqualTo: cpf)
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
        log('Documento com CPF $cpf não encontrado.');
        return 'erro-nao encontrado';
      }
    } catch (e) {
      // Trate erros durante a busca
      log('Erro ao buscar documento: $e');
      return 'erro';
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
                            meuEmail = await findEmailByCPF(cpfCnpjEC.text);
                            /*fica aqui fora pois como o findEmailByCpf eh assincrona,
                            precisa esperar, coisa que o setState nao faz.*/
                            setState(() {});
                            if (meuEmail == 'erro-nao encontrado') {
                              Messages.showError(
                                  'Nao ha um e-mail com esse CPF cadastrado.',
                                  context);
                            }
                            if (meuEmail == 'erro') {
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
                      Positioned(
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
                                child: Text(meuEmail ?? '')),
                          ],
                        ),
                      ),
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

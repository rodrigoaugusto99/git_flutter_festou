import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:git_flutter_festou/src/features/widgets/custom_textformfield.dart';

class CentralDeAjuda extends StatefulWidget {
  const CentralDeAjuda({super.key});

  @override
  State<CentralDeAjuda> createState() => _CentralDeAjudaState();
}

class _CentralDeAjudaState extends State<CentralDeAjuda> {
  final duvidaEC = TextEditingController();
  final mensagemEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> screenshots = ['oiaaaaa', 'eixxxxxx', 'prtrtrtrtrto'];
    List<String> duvidas = [
      'O que é o Festou?',
      'Como posso alugar um espaço para realizar meu evento?',
      'Como posso disponibilizar um espaço?'
    ];
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Container(
            decoration: BoxDecoration(
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
          'Central de ajuda',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              color: const Color(0xffF0F0F0),
              height: 151,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Como podemos te\najudar?',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10.0,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Pesquisar',
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.purple,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset('lib/assets/images/logo_festou.png')
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text('Perguntas Frequentes'),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 10),
              child: SizedBox(
                height: 107,
                child: ListView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  children: screenshots.map((x) {
                    return const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: DuvidaWidget(
                        text: 'oi',
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text('Suporte'),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Ainda precisa de ajuda? Abra seu chamado para o suporte Festou!',
                style: TextStyle(fontSize: 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 41),
              child: ExpansionTile(
                clipBehavior: Clip.none,
                collapsedShape: const RoundedRectangleBorder(
                  side: BorderSide.none,
                ),
                shape: const RoundedRectangleBorder(
                  side: BorderSide.none,
                ),
                //backgroundColor: const Color(0xff9747FF),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 33),
                title: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                        left: 5,
                        child: Image.asset(
                            'lib/assets/images/Icon Calendar1ads.png')),
                    const SizedBox(width: 10),
                    const Positioned(
                      left: 40,
                      child: Text(
                        'Iniciar um chamado',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                children: <Widget>[
                  const SizedBox(height: 8),
                  CustomTextformfield(label: 'Titulo', controller: duvidaEC),
                  const SizedBox(height: 16),
                  CustomTextformfield(
                    label: 'Mensagem',
                    controller: mensagemEC,
                    isBig: true,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upload de imagens (máximo 3)',
                        style: TextStyle(fontSize: 10.5),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 3),
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
                          child: const Icon(
                            Icons.search,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: screenshots.map((x) {
                      return Text(
                        x,
                        style: const TextStyle(fontSize: 10, color: Colors.red),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 3),
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
                        child: const Icon(
                          Icons.search,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DuvidaWidget extends StatelessWidget {
  final String text;
  const DuvidaWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 107,
      width: 143,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: const Color(0xffF0F0F0),
      ),
      child: Text(text),
    );
  }
}

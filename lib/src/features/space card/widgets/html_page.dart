import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:git_flutter_festou/src/models/card_model.dart';

class HtmlPage extends StatelessWidget {
  final String html;
  final CardModel? card;

  const HtmlPage({
    super.key,
    required this.html,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Html(
                data: html,
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
              // const SizedBox(
              //   height: 24,
              // ),
              // Row(
              //   children: [
              //     ElevatedButton(
              //       onPressed: () {
              //         Navigator.of(context).pop(false);
              //       },
              //       child: const Text('Voltar'),
              //     ),
              //     ElevatedButton(
              //       onPressed: () {
              //         Navigator.of(context).pop(true);
              //       },
              //       child: const Text('Assinar de novo'),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 51,
          vertical: 20,
        ),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
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
                onTap: () => Navigator.of(context).pop(true),
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
                    'Assinar de novo',
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
      ),
    );
  }
}

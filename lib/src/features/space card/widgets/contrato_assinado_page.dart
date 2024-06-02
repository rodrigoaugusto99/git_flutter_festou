import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/resumo_reserva_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/summary_data.dart';
import 'package:git_flutter_festou/src/models/cupom_model.dart';
>>>>>>> origin/master
import 'package:git_flutter_festou/src/models/space_model.dart';

class ContratoAssinadoPage extends StatefulWidget {
  final SummaryData summaryData;
  final CupomModel? cupomModel;
  String? html;
  ContratoAssinadoPage({
    super.key,
    required this.summaryData,
    required this.cupomModel,
    required this.html,
  });

  @override
  State<ContratoAssinadoPage> createState() => _ContratoAssinadoPageState();
}

class _ContratoAssinadoPageState extends State<ContratoAssinadoPage> {
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
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResumoReservaPage(
                      assinado: true,
                      summaryData: widget.summaryData,
                      cupomModel: widget.cupomModel,
                      html: widget.html,
                    ),
                  ),
                );
              },
              child: const Text('Continuar reserva'),
            ),
          ],
        ),
      ),
    );
  }
}

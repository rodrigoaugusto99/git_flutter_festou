import 'package:festou/src/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:festou/src/features/space%20card/widgets/resumo_reserva_page.dart';
import 'package:festou/src/features/space%20card/widgets/summary_data.dart';
import 'package:festou/src/models/cupom_model.dart';

class ContratoAssinadoPage extends StatefulWidget {
  final SummaryData? summaryData;
  final CupomModel? cupomModel;
  String? html;
  bool onlyRead;
  CardModel? card;
  bool isPix;
  ContratoAssinadoPage({
    super.key,
    this.summaryData,
    this.cupomModel,
    this.onlyRead = false,
    this.isPix = false,
    this.card,
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
          'Contrato assinado',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: GestureDetector(
          onTap: () {
            if (widget.summaryData == null) {
              Navigator.of(context).pop();
            } else {
              Navigator.pop(context);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResumoReservaPage(
                    assinado: true,
                    summaryData: widget.summaryData!,
                    cupomModel: widget.cupomModel,
                    html: widget.html,
                    card: widget.card,
                    isPix: widget.isPix,
                  ),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
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
            child: Text(
              widget.summaryData == null ? 'Voltar' : 'Continuar reserva',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

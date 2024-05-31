import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/contrato_assinado_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/signature_dialog.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class ContratoPage extends StatefulWidget {
  final DateTime selectedDate;
  final SpaceModel spaceModel;
  final int checkInTime;
  final int checkOutTime;
  final String html;
  const ContratoPage({
    super.key,
    required this.spaceModel,
    required this.selectedDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.html,
  });

  @override
  State<ContratoPage> createState() => _ContratoPageState();
}

class _ContratoPageState extends State<ContratoPage> {
  Future replaceMarkers(
      {required String html,
      // required String cpf,
      // required String name,
      required ui.Image image}) async {
    String modifiedHtml = html;

//todo: replace all markers
    modifiedHtml = modifiedHtml.replaceAll(
        '{Data de Início do Evento}', '<b>${widget.checkInTime}</b>');
    // modifiedHtml = modifiedHtml.replaceAll('{name}', '<b>$name</b>');
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
          html: modifiedHtml,
          spaceModel: widget.spaceModel,
          selectedDate: widget.selectedDate,
          checkInTime: widget.checkInTime,
          checkOutTime: widget.checkOutTime,
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
                    html:
                        '<h1>CONTRATO DE LOCAÇÃO DE ESPAÇO PARA EVENTOS - FESTOU</h1><h2>IDENTIFICAÇÃO DAS PARTES CONTRATANTES</h2><p><strong>LOCADORA:</strong></p><p>Nome da Empresa: {Nome da Empresa Locadora}<br>CNPJ: {CNPJ da Empresa Locadora}</p><p><strong>LOCATÁRIO:</strong></p><p>Nome: {Nome do Cliente}<br>CPF: {CPF do Cliente}</p><h2>OBJETO DO CONTRATO</h2><p>O presente contrato tem como objeto a locação do espaço denominado {Nome do Espaço}, localizado em {Bairro e Município do Espaço}, para a realização de evento conforme os detalhes abaixo.</p><h2>DETALHES DO EVENTO</h2><p>Data de Início: {Data de Início do Evento}<br>Hora de Início: {Hora de Início do Evento}</p><p>Data de Término: {Data de Término do Evento}<br>Hora de Término: {Hora de Término do Evento}</p><h2>DURAÇÃO DA LOCAÇÃO</h2><p>Total de horas locadas: {Número de Horas}</p><h2>VALOR E FORMA DE PAGAMENTO</h2><p>O LOCATÁRIO pagará à LOCADORA o valor de R\$ {Valor por Hora} por hora de utilização do espaço, totalizando R\$ {Valor Total das Horas}.</p><p>Será cobrada uma Taxa Concierge de 3,5% sobre o valor total da locação, correspondendo a R\$ {Valor da Taxa Concierge}.</p><p>Desconto aplicado: R\$ {Valor do Desconto} (Cupom: {Código do Cupom})</p><p><strong>VALOR TOTAL A PAGAR:</strong> R\$ {Valor Total a Pagar}</p><h2>REGRAS DE TAXAS E MULTAS</h2><p><strong>Entrega do Espaço:</strong> O horário de fim de uso é o momento da entrega do espaço. Caso o LOCATÁRIO exceda o tempo contratado, será cobrada uma multa de R\$ {Valor da Multa por Hora Extrapolada} por hora adicional ou fração de hora.</p><p><strong>Pagamento:</strong> O pagamento é efetuado integralmente ao final do processo de reserva, via Pix (que gera uma chave para pagamento de até 5 minutos) ou cartão de crédito.</p><p><strong>Cancelamento:</strong> Em caso de cancelamento por parte do LOCATÁRIO, será aplicada uma taxa de cancelamento de 20% até antes de 48 horas do evento ou 50% em menos de 48 horas antes do evento, não sendo possível cancelar a reserva em menos de 24 horas antes do evento.</p><h2>OBRIGAÇÕES DO LOCATÁRIO</h2><p><strong>Uso Adequado:</strong> Utilizar o espaço de forma adequada, respeitando as regras estabelecidas pela LOCADORA e as normas vigentes.</p><p><strong>Limpeza e Conservação:</strong> Manter o espaço limpo e conservado, sendo responsável por quaisquer danos causados durante o período de locação.</p><p><strong>Segurança:</strong> Responsabilizar-se pela segurança de seus convidados e pelo cumprimento das normas de segurança do espaço.</p><h2>DISPOSIÇÕES GERAIS</h2><p><strong>Alterações:</strong> Qualquer alteração no presente contrato deverá ser feita por escrito e assinada por ambas as partes.</p><p><strong>Jurídico:</strong> Para dirimir quaisquer controvérsias oriundas do presente contrato, as partes elegem o foro da comarca de {Cidade}, estado de {Estado}.</p><h2>ASSINATURA</h2><p>Por estarem de acordo com todas as cláusulas e condições estabelecidas neste contrato, as partes assinam este documento em duas vias de igual teor e forma, juntamente com duas testemunhas.</p><p>{Cidade}, {Data}</p><p><strong>Locadora:</strong><br>[Assinatura registrada do responsável pelo espaço]<br>Responsável pelo espaço: {Nome do responsável pelo espaço}<br>CPF: {CPF do responsável pelo espaço}</p><p><strong>Locatário:</strong><br>[Assinatura do cliente]<br>Responsável pela locação: {Nome do Cliente}<br>CPF: {CPF do Cliente}</p>',
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

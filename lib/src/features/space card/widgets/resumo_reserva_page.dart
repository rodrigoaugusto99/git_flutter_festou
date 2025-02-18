// ignore_for_file: use_full_hex_values_for_flutter_colors, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:festou/src/features/bottomNavBar/profile/pages/reservas%20e%20avalia%C3%A7%C3%B5es/reservas_avaliacoes_page.dart';
import 'package:festou/src/features/loading_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festou/src/features/space%20card/widgets/pix_page2.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/bottomNavBar/profile/pages/pagamentos/pagamentos.dart';
import 'package:festou/src/features/space%20card/widgets/constants2.dart';
import 'package:festou/src/features/space%20card/widgets/contrato_page.dart';
import 'package:festou/src/features/space%20card/widgets/html_page.dart';
import 'package:festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:festou/src/features/space%20card/widgets/summary_data.dart';
import 'package:festou/src/helpers/helpers.dart';
import 'package:festou/src/models/card_model.dart';
import 'package:festou/src/models/cupom_model.dart';
import 'package:festou/src/models/reservation_model.dart';
import 'package:festou/src/models/user_model.dart';
import 'package:festou/src/services/encryption_service.dart';
import 'package:festou/src/services/reserva_service.dart';
import 'package:festou/src/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class DialogBubble extends StatelessWidget {
  final String text;

  const DialogBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            spreadRadius: 2.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12.0,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ResumoReservaPage extends StatefulWidget {
  SummaryData summaryData;
  CupomModel? cupomModel;
  bool assinado;
  String? html;
  CardModel? card;
  bool isPix;
  ResumoReservaPage({
    super.key,
    required this.summaryData,
    required this.cupomModel,
    required this.html,
    this.assinado = false,
    this.card,
    this.isPix = false,
  });

  @override
  State<ResumoReservaPage> createState() => _ResumoReservaPageState();
}

class PointedTriangle extends StatelessWidget {
  const PointedTriangle({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -10,
      left: -10,
      child: Transform.rotate(
        angle: pi / 0.378, // ângulo de rotação em radianos (90 graus)
        child: CustomPaint(
          size: const Size(40, 40),
          painter: TrianglePainter(),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffD9D9D9)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 3, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(1, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _ResumoReservaPageState extends State<ResumoReservaPage> {
  OverlayEntry? _overlayEntry;

  void _showPopup(BuildContext context, Offset offset) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      return;
    }

    final adjustedOffset = offset - const Offset(50, 50);

    _overlayEntry = OverlayEntry(
      // canSizeOverlay: true,
      builder: (context) => GestureDetector(
        onTap: () {},
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => _removePopup(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Positioned(
              left: adjustedOffset.dx + 75,
              top: adjustedOffset.dy - 130,
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Positioned(
                      bottom: -5,
                      left: -5,
                      child: PointedTriangle(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Text(
                          'A Taxa Concierge é\ncobrada para manter\na aplicação no ar,\nsem ela não seria \npossível reunir-mos\nos melhores espaços\npara que o seu\nevento aconteça!'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleTap(BuildContext context, TapDownDetails details) {
    _showPopup(context, details.globalPosition);
  }

  UserModel? userModel;
  String? principalPaymentMethod;
  @override
  void initState() {
    isPix = widget.isPix;
    card = widget.card;
    init();
    super.initState();
  }

  Future<void> showLoading() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Impede que o usuário feche tocando fora
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent, // Deixa apenas a animação visível
        elevation: 0,
        child: CustomLoadingIndicator(),
      ),
    );

    // Fecha o dialog após 3 segundos
    await Future.delayed(const Duration(seconds: 3), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  Future<void> showPaymentLottieDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Impede que o usuário feche tocando fora
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent, // Deixa apenas a animação visível
        elevation: 0,
        child: Lottie.asset(
          'lib/assets/animations/payment.json',
          repeat: false,
          width: 400,
          height: 400,
          //frameRate: const FrameRate(1),
        ),
      ),
    );

    // Fecha o dialog após 3 segundos
    await Future.delayed(const Duration(seconds: 3), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  Future<void> showReservationLottieDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Impede que o usuário feche tocando fora
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent, // Deixa apenas a animação visível
        elevation: 0,
        child: Lottie.asset(
          'lib/assets/animations/party.json',
          width: screenWidth(context),
          height: screenHeight(context),
        ),
      ),
    );

    // Fecha o dialog após 3 segundos
    await Future.delayed(const Duration(seconds: 3), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  Future<void> getPrincipalPaymentMethod() async {
    try {
      final userId = userModel?.docId ?? '';
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        if (userData != null && userData['principal_method_payment'] != null) {
          principalPaymentMethod = userData['principal_method_payment'];
          setFuckingState();
        }
      }
    } catch (e) {
      dev.log('Erro ao verificar o método principal de pagamento: $e');
    }
  }

  void setFuckingState() {
    if (!mounted) return;
    setState(() {});
  }

  void setPrincipalPaymentMethod() {
    if (principalPaymentMethod == null && principalPaymentMethod == '') return;
    if (principalPaymentMethod == 'pix') {
      isPix = true;
      return;
    }
    for (final card in cards) {
      if (card.id == principalPaymentMethod) {
        this.card = card;
      }
    }
    setFuckingState();
  }

  Future<void> init() async {
    await getUser();

    cards = await fetchCardsFromFirestore();

    await getPrincipalPaymentMethod();
    if (!isPix) {
      setPrincipalPaymentMethod();
    }
  }

  List<CardModel> cards = [];

  Future<List<CardModel>> fetchCardsFromFirestore() async {
    final encryptionService =
        EncryptionService("criptfestouaplic", "2199478465899478");
    try {
      // Obter o documento do usuário pelo `userId`
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: userModel!.uid)
          .get();

      // Garantir que os documentos retornados não estejam vazios
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first; // Primeiro usuário encontrado

        // Acessar a subcoleção `cards` dentro do usuário
        final cardsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id) // ID do usuário
            .collection('cards') // Subcoleção
            .get();

        // Mapear os documentos da subcoleção `cards` para `CardModel`
        return cardsSnapshot.docs.map((cardDoc) {
          final data = cardDoc.data();

          // Descriptografar os campos sensíveis
          return CardModel(
            id: cardDoc.id,
            name: data['name'],
            cardName: data['cardName'],
            number: encryptionService
                .decrypt(data['number']), // Descriptografar número
            validateDate: encryptionService
                .decrypt(data['validateDate']), // Descriptografar validade
            cvv: encryptionService.decrypt(data['cvv']), // Descriptografar CVV
          );
        }).toList();
      } else {
        // Caso nenhum usuário seja encontrado, retorne uma lista vazia
        return [];
      }
    } catch (e) {
      throw Exception('Erro ao buscar os dados: $e');
    }
  }

  CardModel? card;
  bool isPix = false;
  Future<void> getUser() async {
    UserService userService = UserService();
    userModel = await userService.getCurrentUserModel();
  }

  DateTime? dataTermino;

  Future replaceMarkers({
    // required String cpf,
    // required String name,
    required String valorTotalDasHoras,
    required String valorDaTaxaConcierge,
    required String valorTotalAPagar,
    required String valorDaMultaPorHoraExtrapolada,
    required String nomeDoCliente,
    required String cpfDoCliente,

    // required String nomeDoCliente,
    // required String nomeDoCliente,
    ui.Image? image,
    required hoursDifference,
  }) async {
    if (userModel == null) {
      dev.log('User is null');
      return;
    }

    if (widget.html != null && widget.assinado) {
      dev.log('tem um html assinado na memoria hein');
    }
    if (widget.html == null) {
      dev.log('nao tem html');
    }
    if (!widget.assinado) {
      dev.log('nao ta assinado');
    }
    if (!widget.assinado && widget.html == null) {
      dev.log('nao ta assinado, n existe html');
    }
    String modifiedHtml = '';
    if (cupomModel != null) {
      modifiedHtml = Constants2.html;
    } else {
      modifiedHtml = Constants2.htmlSemCupom;
    }

    widget.summaryData.valorTotalDasHoras = valorTotalDasHoras;
    widget.summaryData.valorDaTaxaConcierge = valorDaTaxaConcierge;
    // if (cupomModel != null) {
    //   widget.summaryData.cupomModel.valorDesconto = int.parse(valorDoDesconto);
    //   widget.summaryData.cupomModel.codigo = codigoDoCupom;
    // }

    widget.summaryData.valorTotalAPagar = valorTotalAPagar;
    widget.summaryData.valorDaMultaPorHoraExtrapolada =
        valorDaMultaPorHoraExtrapolada;
    widget.summaryData.nomeDoCliente = nomeDoCliente;
    widget.summaryData.cpfDoCliente = cpfDoCliente;
    widget.summaryData.nomeDoLocador = hoursDifference;
    widget.summaryData.cpfDoLocador = hoursDifference;

//todo: replace all markers
    modifiedHtml = modifiedHtml.replaceAll('{Hora de Início do Evento}',
        '<b>${widget.summaryData.checkInTime}:00h</b>');
    modifiedHtml = modifiedHtml.replaceAll('{Hora de Término do Evento}',
        '<b>${widget.summaryData.checkOutTime}:59h</b>');
    modifiedHtml = modifiedHtml.replaceAll('{Data de Início do Evento}',
        '<b>${DateFormat('d \'de\' MMMM \'de\' y', 'pt_BR').format(widget.summaryData.selectedDate)}</b>');

    // Verificar se o checkOutTime está entre 00 e 04
    dataTermino = widget.summaryData.selectedDate;
    int checkOutTimeStr = widget.summaryData.checkOutTime;
    dataTermino ??= widget.summaryData.selectedDate;
    if (checkOutTimeStr >= 0 && checkOutTimeStr <= 4) {
      dataTermino = dataTermino!.add(const Duration(days: 1));
    }
    widget.summaryData.selectedFinalDate = dataTermino;
    dev.log(dataTermino.toString());

// Substituir a data de término do evento
    modifiedHtml = modifiedHtml.replaceAll('{Data de Término do Evento}',
        '<b>${DateFormat('d \'de\' MMMM \'de\' y', 'pt_BR').format(dataTermino!)}</b>');
    modifiedHtml =
        modifiedHtml.replaceAll('{Número de Horas}', '<b>$hoursDifference</b>');
    modifiedHtml = modifiedHtml.replaceAll('{Valor por Hora}',
        '<b>${trocarPontoPorVirgula(widget.summaryData.spaceModel.preco)}</b>');
    modifiedHtml = modifiedHtml.replaceAll('{Valor Total das Horas}',
        '<b>${widget.summaryData.valorTotalDasHoras}</b>');
    modifiedHtml = modifiedHtml.replaceAll('{Valor da Taxa Concierge}',
        '<b>${widget.summaryData.valorDaTaxaConcierge}</b>');
    if (cupomModel != null) {
      modifiedHtml = modifiedHtml.replaceAll(
          '{Valor do Desconto}', '<b>${cupomModel!.valorDesconto}</b>');
      modifiedHtml = modifiedHtml.replaceAll(
          '{Código do Cupom}', '<b>${cupomModel!.codigo}</b>');
    }
    modifiedHtml = modifiedHtml.replaceAll('{Valor Total a Pagar}',
        '<b>${widget.summaryData.valorTotalAPagar}</b>');
    modifiedHtml = modifiedHtml.replaceAll(
        '{Valor da Multa por Hora Extrapolada}',
        '<b>${widget.summaryData.valorDaMultaPorHoraExtrapolada}</b>');
    modifiedHtml = modifiedHtml.replaceAll(
        '{Cidade}', '<b>${widget.summaryData.spaceModel.cidade}</b>');

    modifiedHtml = modifiedHtml.replaceAll('{Data}',
        '<b>${DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(DateTime.now())}</b>');
//Nome Responsável

    modifiedHtml = modifiedHtml.replaceAll(
        '{Nome do Espaço}', '<b>${widget.summaryData.spaceModel.titulo}</b>');
    //todo: municipio
    modifiedHtml = modifiedHtml.replaceAll('{Bairro e Município do Espaço}',
        '<b>${widget.summaryData.spaceModel.bairro}, ${widget.summaryData.spaceModel.cidade}</b>');
    modifiedHtml = modifiedHtml.replaceAll(
        '{Nome do Cliente}', '<b>${userModel!.name}</b>');
    modifiedHtml =
        modifiedHtml.replaceAll('{CPF do Cliente}', '<b>${userModel!.cpf}</b>');

    modifiedHtml = modifiedHtml.replaceAll('{CPF do responsável pelo espaço}',
        '<b>${widget.summaryData.spaceModel.locadorCpf}</b>');
    modifiedHtml = modifiedHtml.replaceAll(
        '{Estado}', '<b>${widget.summaryData.spaceModel.estado}</b>');
    modifiedHtml = modifiedHtml.replaceAll('{Nome da Empresa Locadora}',
        '<b>${widget.summaryData.spaceModel.nomeEmpresaLocadora}</b>');
    if (widget.summaryData.spaceModel.cnpjEmpresaLocadora.isNotEmpty) {
      modifiedHtml = modifiedHtml.replaceAll('{CNPJ da Empresa Locadora}',
          '<b>${widget.summaryData.spaceModel.cnpjEmpresaLocadora}</b>');
      modifiedHtml = modifiedHtml.replaceAll('{CNPJ ou CPF}', 'CNPJ');
      modifiedHtml =
          modifiedHtml.replaceAll('{Tipo pessoa}', 'Pessoa jurídica');
      modifiedHtml = modifiedHtml.replaceAll('{Nome Responsável}',
          '<b>${widget.summaryData.spaceModel.nomeEmpresaLocadora}</b>');
    } else {
      modifiedHtml = modifiedHtml.replaceAll('{CNPJ da Empresa Locadora}',
          '<b>${widget.summaryData.spaceModel.locadorCpf}</b>');
      modifiedHtml = modifiedHtml.replaceAll('{CNPJ ou CPF}', 'CPF');
      modifiedHtml = modifiedHtml.replaceAll('{Nome Responsável}',
          '<b>${widget.summaryData.spaceModel.locadorName}</b>');
      modifiedHtml = modifiedHtml.replaceAll('{Tipo pessoa}', 'Pessoa física');
    }

    modifiedHtml = modifiedHtml.replaceAll(
        '[Assinatura registrada do responsável pelo espaço]',
        '<img src="${widget.summaryData.spaceModel.locadorAssinatura}" alt="Descrição da imagem"/>');

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContratoPage(
          summaryData: widget.summaryData,
          cupomModel: cupomModel,
          html: modifiedHtml,
          card: card,
          isPix: isPix,
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

  final TextEditingController cupomController = TextEditingController();

  CupomModel? cupomModel;

  void checkCupom() async {
    //todo: ver se existe
    UserService userService = UserService();
    String codigo = cupomController.text;
    final cupom = await userService.getCupom(codigo);
    if (cupom == null) {
      Messages.showError('Cupom inválido', context);
      dev.log('Cupom nao existe');
      return;
    }
    dev.log('Cupom existe!!');
    //todo: ver se eh valido
    DateTime cupomValidade = cupom.validade.toDate();
    if (!cupomValidade.isAfter(DateTime.now())) {
      dev.log('Cupom nao eh valido');
      Messages.showError('Cupom expirado', context);
      return;
    }
    //todo: aplicar
    dev.log('Cupom eh valido!!');

    cupomController.text = '';
    cupomModel = cupom;

    setFuckingState();
  }

  @override
  Widget build(BuildContext context) {
    //dev.log(name: 'widget.cupomModel!.codigo', widget.cupomModel!.codigo);
    //dev.log(name: 'cupomModel!.codigo', cupomModel!.codigo);
    int hoursDifference =
        widget.summaryData.checkOutTime - widget.summaryData.checkInTime + 1;
    if (hoursDifference < 0) {
      hoursDifference += 24; // Adjust for crossing midnight
    }
    String formattedDate = DateFormat("d 'de' MMMM 'de' y", 'pt_BR')
        .format(widget.summaryData.selectedDate);
    widget.summaryData.checkOutTime.toString().padLeft(2, '0');
    String dayLabel = (widget.summaryData.checkOutTime >= 0 &&
            widget.summaryData.checkOutTime <= 6)
        ? 'seguinte'
        : formattedDate;

    // Convert price string to double
    // double price = double.tryParse(widget.summaryData.spaceModel.preco
    //         .replaceAll(RegExp(r'[^0-9,]'), '')
    //         .replaceAll(',', '.')) ??
    //     0.0;

    double? price = double.tryParse(widget.summaryData.spaceModel.preco);
    // double? price =
    //     transformarParaFormatoDecimal(widget.summaryData.spaceModel.preco);

    double totalPrice = hoursDifference * (price ?? 200.00);

    // Calculate 3.5% of total price
    double feePercentage = 3.5 / 100;
    double feeAmount = totalPrice * feePercentage;

    // Calculate final price after adding fee and subtracting cupom
    double? finalPrice;
    if (cupomModel != null) {
      finalPrice = (totalPrice + feeAmount) - cupomModel!.valorDesconto;
      setFuckingState();
    } else {
      finalPrice = (totalPrice + feeAmount);
    }

    // Format total price, fee amount, and final price as currency
    String formattedTotalPrice =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
            .format(totalPrice);
    String formattedFeeAmount =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(feeAmount);
    String formattedFinalPrice =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
            .format(finalPrice);

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
          'Resumo da reserva',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Resumo do evento',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                // padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8, left: 38),
                          child: Text(
                            'Seu evento acontecerá em:',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        height: 260,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: CarouselSlider(
                                items: widget.summaryData.spaceModel.imagesUrl
                                    .map((imageUrl) => Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                        ))
                                    .toList(),
                                options: CarouselOptions(
                                  autoPlay: true,
                                  aspectRatio: 16 / 12,
                                  viewportFraction: 1.0,
                                  enableInfiniteScroll: true,
                                  // onPageChanged: (index, reason) {
                                  //   setState(() {
                                  //     _currentIndex = index;
                                  //   });
                                  // },
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 20,
                              right: 20,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 250,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 20,
                                                offset: const Offset(0, 3),
                                              ),
                                            ]),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, left: 25),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    capitalizeFirstLetter(widget
                                                        .summaryData
                                                        .spaceModel
                                                        .titulo),
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'RedHatDisplay',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25),
                                              child: Text(
                                                style: TextStyle(
                                                    color: Colors.blueGrey[500],
                                                    fontSize: 11),
                                                capitalizeTitle(
                                                    "${widget.summaryData.spaceModel.bairro}, ${widget.summaryData.spaceModel.cidade}"),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25, right: 30),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: _getColor(
                                                            double.parse(widget
                                                                .summaryData
                                                                .spaceModel
                                                                .averageRating),
                                                          ),
                                                        ),
                                                        height: 20,
                                                        width: 20,
                                                        child: Center(
                                                          child: Text(
                                                            double.parse(widget
                                                                    .summaryData
                                                                    .spaceModel
                                                                    .averageRating)
                                                                .toStringAsFixed(
                                                                    1),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 3),
                                                      Text(
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xff5E5E5E),
                                                            fontSize: 10,
                                                          ),
                                                          '(${widget.summaryData.spaceModel.numComments})'),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: const Color(
                                                              0xff9747FF),
                                                        ),
                                                        width: 20,
                                                        height: 20,
                                                        child: const Icon(
                                                          Icons.attach_money,
                                                          size: 15,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 3),
                                                      Text(
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xff9747FF),
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                        "R\$ ${trocarPontoPorVirgula(widget.summaryData.spaceModel.preco)}/h",
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.favorite,
                                                        size: 20,
                                                        color:
                                                            Color(0xff9747FF),
                                                      ),
                                                      const SizedBox(width: 3),
                                                      Text(
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xff5E5E5E),
                                                            fontSize: 10,
                                                          ),
                                                          "(${widget.summaryData.spaceModel.numLikes})"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 38),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Com início em:',
                              style: TextStyle(fontSize: 12),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                children: [
                                  Text(
                                    '${widget.summaryData.checkInTime}:00h ',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const Text('do dia ',
                                      style: TextStyle(fontSize: 12)),
                                  Text(
                                    '${DateFormat('d \'de\' MMMM \'de\' y', 'pt_BR').format(widget.summaryData.selectedDate)}:',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'Com término em:',
                              style: TextStyle(fontSize: 12),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                children: [
                                  Text(
                                    '${widget.summaryData.checkOutTime}:59h ',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const Text('do dia ',
                                      style: TextStyle(fontSize: 12)),
                                  Text(
                                    dayLabel,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text('Totalizando ',
                                    style: TextStyle(fontSize: 12)),
                                Text(
                                  hoursDifference.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                                const Text(' horas',
                                    style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              const Text('Você tem um cupom?'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: TextField(
                              controller: cupomController,
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(fontSize: 12),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'lib/assets/images/imagem_cupom.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                hintText: 'Digite seu cupom aqui',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          height: 47,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff9747FF),
                                Color(0xff44300b1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: checkCupom,
                            child: const Text(
                              'Aplicar',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (cupomModel != null || widget.cupomModel != null)
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Cupom aplicado',
                            style: TextStyle(fontSize: 10, color: Colors.red),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    if (cupomModel != null || widget.cupomModel != null)
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 97, vertical: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Text(
                              cupomModel != null
                                  ? cupomModel!.codigo
                                  : widget.cupomModel!.codigo,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Remover Cupom'),
                                    content: const Text(
                                        'Você tem certeza que quer remover o cupom? Se fizer isso, você terá que refazer a assinatura.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Remover'),
                                        onPressed: () {
                                          cupomModel = null;
                                          widget.cupomModel = null;
                                          widget.assinado = false;
                                          widget.html = null;

                                          setFuckingState();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Remover',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                'Resumo de valores',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(
                height: 14,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subtotal',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: hoursDifference.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' horas ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                const TextSpan(
                                  text: 'x ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                const TextSpan(
                                  text: 'R\$ ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: trocarPontoPorVirgula(
                                      widget.summaryData.spaceModel.preco),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formattedTotalPrice,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Text(
                          'Taxa Concierge',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTapDown: (details) => _handleTap(context, details),
                          child: const Icon(
                            Icons.help_outlined,
                            color: Color(0xff595959),
                            size: 17,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: '3,5 ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                const TextSpan(
                                  text: '% ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                const TextSpan(
                                  text: 'x ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                const TextSpan(
                                  text: 'R\$ ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: formattedTotalPrice,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formattedFeeAmount,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (cupomModel != null || widget.cupomModel != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Cupom adicionado',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            cupomModel != null
                                ? '- R\$ ${cupomModel!.valorDesconto}'
                                : '- R\$ ${widget.cupomModel!.valorDesconto}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.cupomModel != null
                              ? NumberFormat.currency(
                                      locale: 'pt_BR', symbol: 'R\$')
                                  .format(finalPrice -
                                      widget.cupomModel!.valorDesconto)
                              : formattedFinalPrice,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Selecionar método de pagamento',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (card != null) ...[
                      Image.asset(
                        'lib/assets/images/icon_card_color.png',
                        height: 23,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Cartão ${card!.number.substring(0, 4)}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else if (card == null && isPix) ...[
                      Image.asset(
                        'lib/assets/images/logo_pix.png',
                        height: 15,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "Pix",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else if (card == null && !isPix) ...[
                      const Text(
                        "Nenhum método selecionado",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        dynamic response = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const Pagamentos(
                                isReservationFlow: true,
                              );
                            },
                          ),
                        );
                        if (response == null) return;
                        if (response is CardModel) {
                          card = response;
                          isPix = false;
                        } else if (response is bool && response) {
                          isPix = true;
                          card = null;
                        }

                        setFuckingState();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Text(
                          card == null && !isPix ? 'Escolher' : 'Trocar',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Contrato',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () async {
                  //todo: ver contrato assinado
                  //todo: la dentro perguntar se quer assinar de novo
                  if (widget.html != null) {
                    dev.log('nav to hjtml page');
                    final response = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HtmlPage(
                          html: widget.html!,
                          card: card,
                        ),
                      ),
                    );
                    if (response == null) return;
                    if (response) {
                      replaceMarkers(
                        hoursDifference: hoursDifference.toString(),
                        image: null,
                        valorTotalDasHoras: formattedTotalPrice,
                        // valorDoDesconto: cupomModel != null
                        //     ? cupomModel!.valorDesconto.toString()
                        //     : '0',
                        valorDaTaxaConcierge: formattedFeeAmount,
                        //codigoDoCupom: cupomModel != null ? cupomModel!.codigo : '',
                        valorTotalAPagar: formattedFinalPrice,
                        valorDaMultaPorHoraExtrapolada: '',
                        nomeDoCliente: '',
                        cpfDoCliente: '',
                      );
                      return;
                    } else {
                      dev.log('usuario viu o html e nao quis trocar');
                      return;
                    }
                  } else {
                    dev.log('nav to contrato');
                    replaceMarkers(
                      hoursDifference: hoursDifference.toString(),
                      image: null,
                      valorTotalDasHoras: formattedTotalPrice,
                      // valorDoDesconto: cupomModel != null
                      //     ? cupomModel!.valorDesconto.toString()
                      //     : '0',
                      valorDaTaxaConcierge: formattedFeeAmount,
                      //codigoDoCupom: cupomModel != null ? cupomModel!.codigo : '',
                      valorTotalAPagar: formattedFinalPrice,
                      valorDaMultaPorHoraExtrapolada: '',
                      nomeDoCliente: '',
                      cpfDoCliente: '',
                    );
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: widget.assinado == false
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ler e assinar contrato',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 15,
                            ),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Contrato',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            Text(
                              'Assinar novamente?',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              if (widget.assinado == false)
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    'É necessário assinar o contrato antes de finalizar a reserva',
                    style: TextStyle(fontSize: 10, color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: GestureDetector(
          onTap: () async {
            //dev.log(widget.html.toString());
            dev.log(widget.summaryData.selectedFinalDate.toString());
            if (!isPix && card == null) {
              Messages.showInfo(
                  'Selecione um método de pagamento para continuar', context);
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PixPage2(),
              ),
            );
            return;

            if (widget.assinado && widget.html != null && userModel != null) {
              //todo: pode reservar

              await showLoading();
              if (card != null) {
                await showPaymentLottieDialog();
              } else if (isPix) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PixPage2(),
                  ),
                );
              }

              // await showReservationLottieDialog();
              try {
                final reservationModel = ReservationModel(
                  spaceId: widget.summaryData.spaceModel.spaceId,
                  locadorId: widget.summaryData.spaceModel.userId,
                  clientId: userModel!.uid,
                  checkInTime: widget.summaryData.checkInTime,
                  checkOutTime: widget.summaryData.checkOutTime,
                  hasReview: false,
                  selectedDate:
                      Timestamp.fromDate(widget.summaryData.selectedDate),
                  selectedFinalDate:
                      Timestamp.fromDate(widget.summaryData.selectedFinalDate!),
                  contratoHtml: widget.html!,
                  cardId: card?.id,
                );

                dev.log('Pode reservar.');
                await ReservaService()
                    .saveReservation(reservationModel: reservationModel);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReservasAvaliacoesPage(userId: userModel!.uid)),
                );
                Messages.showSuccess('Reserva concluída com sucesso', context);
              } on Exception catch (e) {
                dev.log(e.toString());
                Messages.showError(
                    'Não foi possível concluir a reserva', context);
              }
            } else {
              //todo: nao pode reservar
              Messages.showInfo('Assine o contrato para alugar', context);
              dev.log('NAO pode reservar.');
              Messages.showInfo('Complete os dados para continuar', context);
            }
          },
          child: Container(
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
                'Reservar',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              )),
        ),
      ),
    );
  }

  Color _getColor(double averageRating) {
    if (averageRating >= 4) {
      return Colors.green; // Ícone verde para rating maior ou igual a 4
    } else if (averageRating >= 2 && averageRating < 4) {
      return Colors.orange; // Ícone laranja para rating entre 2 e 4 (exclusive)
    } else {
      return Colors.red; // Ícone vermelho para rating abaixo de 2
    }
  }
}

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/contrato_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:intl/intl.dart';

class DialogBubble extends StatelessWidget {
  final String text;

  const DialogBubble({Key? key, required this.text}) : super(key: key);

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

class ResumoReservaPage extends StatefulWidget {
  final DateTime selectedDate;
  final SpaceModel spaceModel;
  final int checkInTime;
  final int checkOutTime;
  bool assinado;
  ResumoReservaPage({
    super.key,
    required this.spaceModel,
    required this.selectedDate,
    required this.checkInTime,
    required this.checkOutTime,
    this.assinado = false,
  });

  @override
  State<ResumoReservaPage> createState() => _ResumoReservaPageState();
}

class PointedTriangle extends StatelessWidget {
  const PointedTriangle({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -13,
      left: -5,
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
              left: adjustedOffset.dx + 85,
              top: adjustedOffset.dy - 120,
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
                          horizontal: 20, vertical: 5),
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

  Future replaceMarkers(
      {required String html,
      // required String cpf,
      // required String name,
      ui.Image? image}) async {
    String modifiedHtml = html;

//todo: replace all markers
    modifiedHtml = modifiedHtml.replaceAll(
        '{Data de Início do Evento}', '<b>${widget.checkInTime}</b>');
    // modifiedHtml = modifiedHtml.replaceAll('{name}', '<b>$name</b>');
    // modifiedHtml = modifiedHtml.replaceAll('{name}', '<b>$name</b>');
    // modifiedHtml = modifiedHtml.replaceAll('{name}', '<b>$name</b>');
    // modifiedHtml = modifiedHtml.replaceAll('{name}', '<b>$name</b>');

    String base64Image = '';
    if (image != null) {
      base64Image = await imageToBase64(image);
    }
    modifiedHtml += '<img src="$base64Image" alt="Descrição da imagem"/>';
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ContratoPage(
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
    int cupom = 51;
    int hoursDifference = widget.checkOutTime - widget.checkInTime;
    if (hoursDifference < 0) {
      hoursDifference += 24; // Adjust for crossing midnight
    }
    String formattedDate =
        DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(widget.selectedDate);
    String formattedCheckOutTime =
        widget.checkOutTime.toString().padLeft(2, '0');
    String dayLabel = (widget.checkOutTime >= 0 && widget.checkOutTime <= 6)
        ? 'seguinte'
        : formattedDate;

    // Convert price string to double
    double price = double.tryParse(widget.spaceModel.preco
            .replaceAll(RegExp(r'[^0-9,]'), '')
            .replaceAll(',', '.')) ??
        0.0;
    double totalPrice = hoursDifference * price;

    // Calculate 3.5% of total price
    double feePercentage = 3.5 / 100;
    double feeAmount = totalPrice * feePercentage;

    // Calculate final price after adding fee and subtracting cupom
    int finalPrice = (totalPrice + feeAmount).round() - cupom;

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
                                items: widget.spaceModel.imagesUrl
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
                                                        .spaceModel.titulo),
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
                                                    "${widget.spaceModel.bairro}, ${widget.spaceModel.cidade}"),
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
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: _getColor(
                                                        double.parse(widget
                                                            .spaceModel
                                                            .averageRating),
                                                      ),
                                                    ),
                                                    height: 20,
                                                    width: 20,
                                                    child: Center(
                                                      child: Text(
                                                        double.parse(widget
                                                                .spaceModel
                                                                .averageRating)
                                                            .toStringAsFixed(1),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10),
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff5E5E5E),
                                                        fontSize: 10,
                                                      ),
                                                      "(105)"),
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
                                                    ],
                                                  ),
                                                  const Text(
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff9747FF),
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                    "R\$800,00/h",
                                                  ),
                                                  const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.favorite,
                                                        size: 20,
                                                        color:
                                                            Color(0xff9747FF),
                                                      ),
                                                      Text(
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff5E5E5E),
                                                            fontSize: 10,
                                                          ),
                                                          "(598)"),
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
                                    '${widget.checkInTime}:00h ',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const Text('do dia ',
                                      style: TextStyle(fontSize: 12)),
                                  Text(
                                    '${DateFormat('d \'de\' MMMM \'de\' y', 'pt_BR').format(widget.selectedDate)}:',
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
                                    '${widget.checkOutTime}:00h ',
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
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(fontSize: 12),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'lib/assets/images/image 18cupm_prefix.png',
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
                            onTap: () {
                              // Ação do botão
                            },
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Cupom aplicado',
                        style: TextStyle(fontSize: 9, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 97, vertical: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: const Text(
                        'FESTOU50!',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Remover',
                        style: TextStyle(fontSize: 9, color: Colors.red),
                      ),
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
                                const TextSpan(
                                  text: '04 ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                const TextSpan(
                                  text: 'horas ',
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
                                  text: '${widget.spaceModel.preco},00',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cupom adicionado',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '- R\$ $cupom,00',
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
                          formattedFinalPrice,
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('lib/assets/images/image 4cartao_reserva.png'),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Cartão Master **** 2580',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const Text(
                      'Trocar',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
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
                  replaceMarkers(
                      html:
                          '<h1>CONTRATO DE LOCAÇÃO DE ESPAÇO PARA EVENTOS - FESTOU</h1><h2>IDENTIFICAÇÃO DAS PARTES CONTRATANTES</h2><p><strong>LOCADORA:</strong></p><p>Nome da Empresa: {Nome da Empresa Locadora}<br>CNPJ: {CNPJ da Empresa Locadora}</p><p><strong>LOCATÁRIO:</strong></p><p>Nome: {Nome do Cliente}<br>CPF: {CPF do Cliente}</p><h2>OBJETO DO CONTRATO</h2><p>O presente contrato tem como objeto a locação do espaço denominado {Nome do Espaço}, localizado em {Bairro e Município do Espaço}, para a realização de evento conforme os detalhes abaixo.</p><h2>DETALHES DO EVENTO</h2><p>Data de Início: {Data de Início do Evento}<br>Hora de Início: {Hora de Início do Evento}</p><p>Data de Término: {Data de Término do Evento}<br>Hora de Término: {Hora de Término do Evento}</p><h2>DURAÇÃO DA LOCAÇÃO</h2><p>Total de horas locadas: {Número de Horas}</p><h2>VALOR E FORMA DE PAGAMENTO</h2><p>O LOCATÁRIO pagará à LOCADORA o valor de R\$ {Valor por Hora} por hora de utilização do espaço, totalizando R\$ {Valor Total das Horas}.</p><p>Será cobrada uma Taxa Concierge de 3,5% sobre o valor total da locação, correspondendo a R\$ {Valor da Taxa Concierge}.</p><p>Desconto aplicado: R\$ {Valor do Desconto} (Cupom: {Código do Cupom})</p><p><strong>VALOR TOTAL A PAGAR:</strong> R\$ {Valor Total a Pagar}</p><h2>REGRAS DE TAXAS E MULTAS</h2><p><strong>Entrega do Espaço:</strong> O horário de fim de uso é o momento da entrega do espaço. Caso o LOCATÁRIO exceda o tempo contratado, será cobrada uma multa de R\$ {Valor da Multa por Hora Extrapolada} por hora adicional ou fração de hora.</p><p><strong>Pagamento:</strong> O pagamento é efetuado integralmente ao final do processo de reserva, via Pix (que gera uma chave para pagamento de até 5 minutos) ou cartão de crédito.</p><p><strong>Cancelamento:</strong> Em caso de cancelamento por parte do LOCATÁRIO, será aplicada uma taxa de cancelamento de 20% até antes de 48 horas do evento ou 50% em menos de 48 horas antes do evento, não sendo possível cancelar a reserva em menos de 24 horas antes do evento.</p><h2>OBRIGAÇÕES DO LOCATÁRIO</h2><p><strong>Uso Adequado:</strong> Utilizar o espaço de forma adequada, respeitando as regras estabelecidas pela LOCADORA e as normas vigentes.</p><p><strong>Limpeza e Conservação:</strong> Manter o espaço limpo e conservado, sendo responsável por quaisquer danos causados durante o período de locação.</p><p><strong>Segurança:</strong> Responsabilizar-se pela segurança de seus convidados e pelo cumprimento das normas de segurança do espaço.</p><h2>DISPOSIÇÕES GERAIS</h2><p><strong>Alterações:</strong> Qualquer alteração no presente contrato deverá ser feita por escrito e assinada por ambas as partes.</p><p><strong>Jurídico:</strong> Para dirimir quaisquer controvérsias oriundas do presente contrato, as partes elegem o foro da comarca de {Cidade}, estado de {Estado}.</p><h2>ASSINATURA</h2><p>Por estarem de acordo com todas as cláusulas e condições estabelecidas neste contrato, as partes assinam este documento em duas vias de igual teor e forma, juntamente com duas testemunhas.</p><p>{Cidade}, {Data}</p><p><strong>Locadora:</strong><br>[Assinatura registrada do responsável pelo espaço]<br>Responsável pelo espaço: {Nome do responsável pelo espaço}<br>CPF: {CPF do responsável pelo espaço}</p><p><strong>Locatário:</strong><br>[Assinatura do cliente]<br>Responsável pela locação: {Nome do Cliente}<br>CPF: {CPF do Cliente}</p>',
                      image: null);
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
                      : const Text(
                          'Contrato assinado',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              const Text(
                'É necessário assinar o contrato antes de finalizar a reserva',
                style: TextStyle(fontSize: 9, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: GestureDetector(
          onTap: () {
            if (widget.assinado) {
              //todo: pode reservar
            } else {
              //todo: nao pode reservar
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

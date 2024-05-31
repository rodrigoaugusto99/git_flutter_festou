import 'dart:math';

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContratoPage(
                        spaceModel: widget.spaceModel,
                        selectedDate: widget.selectedDate,
                        checkInTime: widget.checkInTime,
                        checkOutTime: widget.checkOutTime,
                      ),
                    ),
                  );
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

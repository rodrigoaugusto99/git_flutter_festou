import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/contrato_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class ResumoReservaPage extends StatefulWidget {
  final DateTime? selectedDate;
  final SpaceModel? spaceModel;
  final int? checkInTime;
  final int? checkOutTime;
  final bool assinado;

  const ResumoReservaPage({
    super.key,
    this.spaceModel,
    this.selectedDate,
    this.checkInTime,
    this.checkOutTime,
    this.assinado = false,
  });

  @override
  State<ResumoReservaPage> createState() => _ResumoReservaPageState();
}

class _ResumoReservaPageState extends State<ResumoReservaPage> {
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
          'Resumo da reserva',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Resumo do evento',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const Text('Seu evento acontecerá em:'),
                    SizedBox(
                      width: 300,
                      height: 260,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: CarouselSlider(
                              items: widget.spaceModel!.imagesUrl
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
                                              color:
                                                  Colors.grey.withOpacity(0.5),
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
                                                      .spaceModel!.titulo),
                                                  style: const TextStyle(
                                                    fontFamily: 'RedHatDisplay',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 25),
                                            child: Text(
                                              style: TextStyle(
                                                  color: Colors.blueGrey[500],
                                                  fontSize: 11),
                                              capitalizeTitle(
                                                  "${widget.spaceModel!.bairro}, ${widget.spaceModel!.cidade}"),
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
                                                          .spaceModel!
                                                          .averageRating),
                                                    ),
                                                  ),
                                                  height: 20,
                                                  width: 20,
                                                  child: Center(
                                                    child: Text(
                                                      double.parse(widget
                                                              .spaceModel!
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
                                                      color: Color(0xff5E5E5E),
                                                      fontSize: 10,
                                                    ),
                                                    "(105)"),
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
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
                                                      color: Color(0xff9747FF),
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
                                                      color: Color(0xff9747FF),
                                                    ),
                                                    Text(
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff5E5E5E),
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
                    const Text('Com início em:'),
                    const Text('xxxxx'),
                    const Text('Com término em:'),
                    const Text('yyyy'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Você tem um cupom?'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              'lib/assets/images/image 18cupm_prefix.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                          hintText: 'Digite seu cupom aqui',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        // Ação do botão
                      },
                      child: const Text('Aplicar'),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: const Text(
                  'nome do cupom',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const Text(
                'Resumo de valores',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: const Column(
                  children: [
                    Text(
                      'Subtotal',
                      style: TextStyle(fontSize: 12),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '04 horas x R\$ 800,00',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'R\$ 3200,00',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          'Taxa Concierge',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.question_mark)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '3,5% x R\$ 3200,00',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'R\$ 112,00',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cupom adicionado',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '- R\$ 50,00',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '- R\$ 50,00',
                          style: TextStyle(
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
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContratoPage(
                        spaceModel: widget.spaceModel!,
                        selectedDate: widget.selectedDate!,
                        checkInTime: widget.checkInTime!,
                        checkOutTime: widget.checkOutTime!,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                            Icon(Icons.arrow_forward_ios_outlined),
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
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: widget.assinado
                ? Colors.purple
                : Colors.purple[100], // Cor do botão
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Bordas arredondadas
            ),
          ),
          onPressed: () {
            if (widget.assinado) {
              //todo: pode reservar
            } else {
              //todo: nao pode reservar
            }
          },
          child: const Text('Reservar'),
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

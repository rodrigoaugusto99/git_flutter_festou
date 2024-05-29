import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/bottomNavBar/profile/pages/minhas%20atividades/minhas%20reservas/minhas_reservas_state.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/repositories/reservation/reservation_firestore_repository_impl.dart';

class ReservasWidget extends StatefulWidget {
  final MinhasReservasState data;
  const ReservasWidget({
    super.key,
    required this.data,
  });

  @override
  State<ReservasWidget> createState() => _ReservasWidgetState();
}

class _ReservasWidgetState extends State<ReservasWidget> {
  List<SpaceModel> listOfSpaces = [];

  @override
  void initState() {
    super.initState();
    _fetchSpaceModels();
  }

  void _fetchSpaceModels() async {
    final reservationFirestore = ReservationFirestoreRepositoryImpl();

    for (var x in widget.data.reservas) {
      final spaceId = x.spaceId;

      final spaceModel = await reservationFirestore.getSpaceById(spaceId);
      if (spaceModel != null) {
        setState(() {
          listOfSpaces.add(spaceModel);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log(listOfSpaces.toString());
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.zero,
        leading: Image.asset('lib/assets/images/Icon Calendarcalnd.png'),
        title: const Text('Minhas Reservas'),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listOfSpaces.length,
            itemBuilder: (context, index) {
              final spaceModel = listOfSpaces[index];
              return Column(
                children: [
                  SizedBox(
                    width: 300,
                    height: 260,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: CarouselSlider(
                            items: spaceModel.imagesUrl
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
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                capitalizeFirstLetter(
                                                    spaceModel.titulo),
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
                                                "${spaceModel.bairro}, ${spaceModel.cidade}"),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: _getColor(
                                                    double.parse(spaceModel
                                                        .averageRating),
                                                  ),
                                                ),
                                                height: 20,
                                                width: 20,
                                                child: Center(
                                                  child: Text(
                                                    double.parse(spaceModel
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
                                                          BorderRadius.circular(
                                                              5),
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
                  const SizedBox(
                    height: 30,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    // return ExpansionTile(
    //   title: const Text('Minhas Reservas'),
    //   children: [
    //     ListView.builder(
    //       shrinkWrap: true,
    //       physics: const NeverScrollableScrollPhysics(),
    //       itemCount: widget.data.reservas.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         final reserva = widget.data.reservas[index];
    //         return Column(
    //           crossAxisAlignment: CrossAxisAlignment.stretch,
    //           children: [
    //             const SizedBox(height: 4),
    //             Container(
    //               margin: const EdgeInsets.symmetric(horizontal: 10),
    //               padding: const EdgeInsets.all(16.0),
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(8.0),
    //               ),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(
    //                     'Reserva: ${reserva.range}\nStatus: ${reserva.status}',
    //                     style: const TextStyle(
    //                       fontSize: 16.0,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         );
    //       },
    //     ),
    //   ],
    // );
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

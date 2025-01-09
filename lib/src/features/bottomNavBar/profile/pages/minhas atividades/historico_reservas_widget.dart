import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/new_space_card.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/services/reserva_service.dart';
import 'package:git_flutter_festou/src/services/space_service.dart';
import 'package:intl/intl.dart';

class HistoricoReservasWidget extends StatefulWidget {
  const HistoricoReservasWidget({
    super.key,
  });

  @override
  State<HistoricoReservasWidget> createState() =>
      _HistoricoReservasWidgetState();
}

class _HistoricoReservasWidgetState extends State<HistoricoReservasWidget> {
  @override
  void initState() {
    super.initState();
    getMyReservations();
  }

  Future<void> getMyReservations() async {
    final reservas = await ReservaService().getReservationsByClienId();

    for (final reserva in reservas) {
      final space = await SpaceService().getSpaceById(reserva.spaceId);
      if (space == null) continue;
      spaces.add(space);
    }

    setState(() {});
  }

  List<SpaceModel> spaces = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        leading: Image.asset('lib/assets/images/Icon ratingmyava.png'),
        title: const Text('Minhas reservas'),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: spaces.length,
            itemBuilder: (BuildContext context, int index) {
              final space = spaces[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: HistoricoReservasTile(
                  spaceShowing: space,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HistoricoReservasTile extends StatefulWidget {
  final SpaceModel spaceShowing;
  const HistoricoReservasTile({
    super.key,
    required this.spaceShowing,
  });

  @override
  State<HistoricoReservasTile> createState() => _HistoricoReservasTileState();
}

String formatDateTime(DateTime date, int startHour, int endHour) {
  // Formatar data para 'dd/MM/yyyy'
  String formattedDate = DateFormat('dd/MM/yyyy').format(date);

  // Formatar o horário de início (hh:mm)
  String formattedStartTime = '$startHour:00';

  // Formatar o horário de término (hh:mm)
  String formattedEndTime = '$endHour:59';

  // Montar o formato completo
  return '$formattedDate - $formattedStartTime às $formattedEndTime h';
}

class _HistoricoReservasTileState extends State<HistoricoReservasTile> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //  onTap: () => navToPage(),
      child: Container(
        color: Colors.brown,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: CarouselSlider(
                items: widget.spaceShowing.imagesUrl
                    .map((imageUrl) => Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ))
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 305 / 179,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 270,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    capitalizeFirstLetter(
                                        widget.spaceShowing.titulo),
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
                              padding: const EdgeInsets.only(left: 25),
                              child: Text(
                                style: TextStyle(
                                    color: Colors.blueGrey[500], fontSize: 11),
                                capitalizeTitle(
                                    "${widget.spaceShowing.bairro}, ${widget.spaceShowing.cidade}"),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(
                                color: Color(0xff9747FF),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [],
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
    );
  }
}

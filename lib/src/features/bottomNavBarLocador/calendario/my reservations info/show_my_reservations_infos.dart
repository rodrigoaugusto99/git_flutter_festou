import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/my%20reservations%20info/guest%20feedback/guest_feedback_page.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/my%20reservations%20info/show_my_reservations_info_state.dart';
import 'package:git_flutter_festou/src/features/bottomNavBarLocador/calendario/my%20reservations%20info/show_my_reservations_info_vm.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:table_calendar/table_calendar.dart';

class ShowMyReservationsInfos extends ConsumerStatefulWidget {
  final ReservationModel reserva;
  const ShowMyReservationsInfos({
    super.key,
    required this.reserva,
  });

  @override
  ConsumerState<ShowMyReservationsInfos> createState() =>
      _ShowMyReservationsInfosState();
}

class _ShowMyReservationsInfosState
    extends ConsumerState<ShowMyReservationsInfos> {
  @override
  Widget build(BuildContext context) {
    final showMyReservationsInfosVm =
        ref.watch(showMyReservationsInfosVmProvider(widget.reserva.userId));

    void temCerteza(String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return message == 'confirmar'
              ? AlertDialog(
                  title: const Text(
                      'Ao confirmar a reserva, você terá 24 horas para responder o locatario'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Ação ao pressionar o botão "Confirmar" ou "Recusar"
                        // Coloque sua lógica aqui
                        Navigator.of(context).pop();
                      },
                      child: const Text('Confirmar'),
                    ),
                  ],
                )
              : AlertDialog(
                  title: const Text(
                      'Tem certeza que você deseja recusar a reserva? Essa ação não poderá ser desfeita.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Ação ao pressionar o botão "Confirmar" ou "Recusar"
                        // Coloque sua lógica aqui
                        Navigator.of(context).pop();
                      },
                      child: const Text('Recusar'),
                    ),
                  ],
                );
        },
      );
    }

    void showRatingDialog(String userId) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: GuestFeedbackPage(userId: userId),
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Informacoes dessa reserva'),
        ),
        body: showMyReservationsInfosVm.when(
          data: (ShowMyReservationsInfosState data) {
            return Center(
              child: Column(
                children: [
                  ClipOval(
                    child: Image.network(
                      data.user!.avatarUrl,
                      width: 150,
                      height: 150,
                      fit: BoxFit
                          .cover, // ou outro ajuste de acordo com suas necessidades
                    ),
                  ),
                  //Text('Nome do cliente: ${data.user!.name}'),
                  Text('Nome do cliente: ${data.user!.name}'),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Reserva: ${widget.reserva.range}'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => temCerteza('confirmar'),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          alignment: Alignment.center,
                          width: 100,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const InkWell(child: Text('Confirmar')),
                        ),
                      ),
                      InkWell(
                        onTap: () => temCerteza('recusar'),
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Text('Recusar'),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => showRatingDialog(widget.reserva.userId),
                    child: const Text('Avaliar hospede'),
                  ),
                ],
              ),
            );
          },
          error: (Object error, StackTrace stackTrace) {
            return const Stack(children: [
              Center(child: Text('Inserir imagem melhor papai')),
              Center(child: Icon(Icons.error)),
            ]);
          },
          loading: () {
            return const Stack(children: [
              Center(child: Text('Inserir carregamento Personalizado papai')),
              Center(child: CircularProgressIndicator()),
            ]);
          },
        ));
  }
}

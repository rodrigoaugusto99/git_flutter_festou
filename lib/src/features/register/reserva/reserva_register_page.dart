import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/register/reserva/reserva_register_vm.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ReservaRegisterPage extends ConsumerStatefulWidget {
  final SpaceModel space;
  const ReservaRegisterPage({super.key, required this.space});

  @override
  ConsumerState<ReservaRegisterPage> createState() =>
      _ReservaRegisterPageState();
}

class _ReservaRegisterPageState extends ConsumerState<ReservaRegisterPage> {
  String _range = '';
  String text = 'Nenhuma data selecionada';

  @override
  Widget build(BuildContext context) {
    final reservationVm = ref.watch(reservationRegisterVmProvider.notifier);

    void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      setState(() {
        if (args.value is PickerDateRange && args.value.startDate != null) {
          if (args.value.endDate == null ||
              args.value.startDate == args.value.endDate) {
            //Usuário clicou duas vezes na mesma data ou só selecionou uma
            _range = DateFormat('dd/MM/yyyy').format(args.value.startDate);
            text = 'Data selecionada';

            log('Data única selecionada: $_range');
          } else {
            _range =
                '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} - ${DateFormat('dd/MM/yyyy').format(args.value.endDate)}';
            text = 'Intervalo selecionado';
            log('Intervalo selecionado: $_range');
          }
        }
      });
    }

    void showReservationDialog(String range) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Reserva'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Data: $range'),
                  const Text('Valor da diária: x'),
                  const Text('Desconto: y'),
                  const Text('Impostos/taxa: z'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Confirmar'),
                onPressed: () {
                  //todo: enviar reserva ao banco
                  reservationVm.addToState(_range);
                  reservationVm.register(widget.space.spaceId);

                  // Lógica para confirmar a reserva
                  log('--Reserva confirmada:$_range--');
                  Navigator.of(context).pop(); // Fechar o diálogo
                  Navigator.of(context).pop(); // Fechar CalendarPage
                },
              ),
            ],
          );
        },
      );
    }

    void onReserveButtonPressed() {
      if (_range.isNotEmpty) {
        showReservationDialog(_range);
      } else {
        log('Selecione pelo menos uma data para reservar.');
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('$text: $_range'),
              ],
            ),
          ),
          Expanded(
            child: SfDateRangePicker(
              onSelectionChanged: onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
            ),
          ),
          ElevatedButton(
            onPressed: onReserveButtonPressed,
            child: const Text('Reservar'),
          ),
        ],
      ),
    );
  }
}

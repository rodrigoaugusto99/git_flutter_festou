import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:ticket_widget/ticket_widget.dart';

class CalendarPage extends StatefulWidget {
  final SpaceModel? space;
  const CalendarPage({super.key, this.space});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String _range = '';
  String text = 'Nenhuma data selecionada';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
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

  void _showReservationDialog(String range) async {
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
                // Lógica para confirmar a reserva
                log('Reserva confirmada:$_range');
                Navigator.of(context).pop(); // Fechar o diálogo
                Navigator.of(context).pop(); // Fechar CalendarPage
              },
            ),
          ],
        );
      },
    );
  }

  void _onReserveButtonPressed() {
    if (_range.isNotEmpty) {
      _showReservationDialog(_range);
      log('------Reservado: $_range');
    } else {
      log('Selecione pelo menos uma data para reservar.');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
            ),
          ),
          ElevatedButton(
            onPressed: _onReserveButtonPressed,
            child: const Text('Reservar'),
          ),
        ],
      ),
    );
  }
}

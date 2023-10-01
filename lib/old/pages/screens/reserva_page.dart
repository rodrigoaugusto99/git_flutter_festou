import 'package:flutter/material.dart';
import 'package:git_flutter_festou/old/model/my_card.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/card_reserve.dart';

class ReservaPage extends StatefulWidget {
  final MyCard card;

  const ReservaPage({Key? key, required this.card}) : super(key: key);

  @override
  _ReservaPageState createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {
  DateTime today = DateTime.now();

// Função para marcar as datas já reservadas na lista markedDates
  List<DateTime> markReservedDates(List<Reserva> reservas) {
    List<DateTime> dates = [];
    DateTime today = DateTime.now();

    for (var reserva in reservas) {
      if (reserva.diaDoMes.isAfter(today)) {
        dates.add(reserva.diaDoMes);
      }
    }

    return dates;
  }

  @override
  void initState() {
    super.initState();
    widget.card.markedDates = markReservedDates(widget.card.reservas);
    print(
        "markedDates: ${widget.card.markedDates}"); // Chama a função para marcar as datas reservadas
  }

  //função chamada quando uma data é selecionada
  //adiciona ou remove dependendo se ja estiver selecionado ou nao
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  //horario de 1-24 para o dropdownButton
  List<String> hours =
      List.generate(24, (index) => (index + 1).toString().padLeft(2, '0'));

  //listas de horarios pré-selecionados
  String selectedOpeningHours = '01';
  String selectedClosingHours = '24';

  //cada row com dia da semana, e DropDownButtons
  Widget myRow({
    required String text,
    required String selectedOpeningHour,
    required String selectedClosingHour,
    required List<String> hours,
    required ValueChanged<String?> onOpeningHourChanged,
    required ValueChanged<String?> onClosingHourChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        Row(
          children: [
            DropdownButton<String>(
              value: selectedOpeningHour,
              onChanged: onOpeningHourChanged,
              items: hours.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(width: 8),
            const Text('às'),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: selectedClosingHour,
              onChanged: onClosingHourChanged,
              items: hours.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fazer Reserva'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 10, 16),
                selectedDayPredicate: (day) {
                  return isSameDay(today, day);
                },
                onDaySelected: _onDaySelected,
                calendarStyle: CalendarStyle(
                  markerDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red[500],
                  ),
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple[500],
                  ),
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green[400],
                  ),
                ),
                focusedDay: today,
                // Use calendarBuilders to customize the appearance of calendar cells
                calendarBuilders: CalendarBuilders(
                  // Customize the marked day
                  markerBuilder: (context, day, events) {
                    if (widget.card.markedDates.contains(day)) {
                      return Positioned(
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          width: 10,
                          height: 10,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(height: 20),
              myRow(
                text: 'segunda',
                selectedOpeningHour: selectedOpeningHours,
                selectedClosingHour: selectedClosingHours,
                hours: hours,
                onOpeningHourChanged: (String? newValue) {
                  setState(() {
                    selectedOpeningHours = newValue!;
                  });
                },
                onClosingHourChanged: (String? newValue) {
                  setState(() {
                    selectedClosingHours = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Verifica se já existe uma reserva para o dia selecionado
                  bool hasExistingReserva = widget.card.reservas
                      //DateTime tem a propriedade.day para capturar o DIA.
                      .any((reserva) => reserva.diaDoMes.day == today.day);

                  if (hasExistingReserva) {
                    // Mostra uma mensagem informando que já existe uma reserva para o dia selecionado
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Reserva Existente'),
                          content: Text(
                              'Já existe uma reserva para o dia ${today.day}.'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Cria um DateTime com o dia selecionado
                    DateTime markedDate =
                        DateTime(today.year, today.month, today.day);
                    // Se não houver reserva para o dia selecionado, cria a reserva
                    Reserva reserva = Reserva(
                      diaDoMes: markedDate,
                      horaDeAbertura: selectedOpeningHours,
                      horaDeFechamento: selectedClosingHours,
                    );
                    // Adicione a reserva  ao card ou faça a lógica necessária para armazenar as reservas
                    widget.card.reservas.add(reserva);

                    // Fecha a página de reserva
                    Navigator.pop(context);
                  }
                },
                child: const Text('Confirmar Reserva'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

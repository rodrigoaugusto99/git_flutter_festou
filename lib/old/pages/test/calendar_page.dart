import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime today = DateTime.now();

  //conjunto (Set) de DateTime que armazena as datas selecionadas pelo usuário.
  Set<DateTime> selectedDates = {};

  //função chamada quando uma data é selecionada
  //adiciona ou remove dependendo se ja estiver selecionado ou nao
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      {
        if (selectedDates.contains(day)) {
          selectedDates.remove(day);
        } else {
          selectedDates.add(day);
        }
      }
    });
  }

  //horario de 1-24 para o dropdownButton
  List<String> hours =
      List.generate(24, (index) => (index + 1).toString().padLeft(2, '0'));

  //listas de horarios pré-selecionados
  List<String> selectedOpeningHours = List<String>.filled(7, '01');
  List<String> selectedClosingHours = List<String>.filled(7, '24');

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

  //função para configurar os horarios de abertura e fechamento
  void configureHours() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: Column(
                children: [
                  const Text(
                    "Configure os horarios",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  myRow(
                    text: 'segunda',
                    selectedOpeningHour: selectedOpeningHours[0],
                    selectedClosingHour: selectedClosingHours[0],
                    hours: hours,
                    onOpeningHourChanged: (String? newValue) {
                      setState(() {
                        selectedOpeningHours[0] = newValue!;
                      });
                    },
                    onClosingHourChanged: (String? newValue) {
                      setState(() {
                        selectedClosingHours[0] = newValue!;
                      });
                    },
                  ),
                  myRow(
                    text: 'terça',
                    selectedOpeningHour: selectedOpeningHours[1],
                    selectedClosingHour: selectedClosingHours[1],
                    hours: hours,
                    onOpeningHourChanged: (String? newValue) {
                      setState(() {
                        selectedOpeningHours[1] = newValue!;
                      });
                    },
                    onClosingHourChanged: (String? newValue) {
                      setState(() {
                        selectedClosingHours[1] = newValue!;
                      });
                    },
                  ),
                  myRow(
                    text: 'quarta',
                    selectedOpeningHour: selectedOpeningHours[2],
                    selectedClosingHour: selectedClosingHours[2],
                    hours: hours,
                    onOpeningHourChanged: (String? newValue) {
                      setState(() {
                        selectedOpeningHours[2] = newValue!;
                      });
                    },
                    onClosingHourChanged: (String? newValue) {
                      setState(() {
                        selectedClosingHours[2] = newValue!;
                      });
                    },
                  ),
                  myRow(
                    text: 'quinta',
                    selectedOpeningHour: selectedOpeningHours[3],
                    selectedClosingHour: selectedClosingHours[3],
                    hours: hours,
                    onOpeningHourChanged: (String? newValue) {
                      setState(() {
                        selectedOpeningHours[3] = newValue!;
                      });
                    },
                    onClosingHourChanged: (String? newValue) {
                      setState(() {
                        selectedClosingHours[3] = newValue!;
                      });
                    },
                  ),
                  myRow(
                    text: 'sexta',
                    selectedOpeningHour: selectedOpeningHours[4],
                    selectedClosingHour: selectedClosingHours[4],
                    hours: hours,
                    onOpeningHourChanged: (String? newValue) {
                      setState(() {
                        selectedOpeningHours[4] = newValue!;
                      });
                    },
                    onClosingHourChanged: (String? newValue) {
                      setState(() {
                        selectedClosingHours[4] = newValue!;
                      });
                    },
                  ),
                  myRow(
                    text: 'sábado',
                    selectedOpeningHour: selectedOpeningHours[5],
                    selectedClosingHour: selectedClosingHours[5],
                    hours: hours,
                    onOpeningHourChanged: (String? newValue) {
                      setState(() {
                        selectedOpeningHours[5] = newValue!;
                      });
                    },
                    onClosingHourChanged: (String? newValue) {
                      setState(() {
                        selectedClosingHours[5] = newValue!;
                      });
                    },
                  ),
                  myRow(
                    text: 'domingo',
                    selectedOpeningHour: selectedOpeningHours[6],
                    selectedClosingHour: selectedClosingHours[6],
                    hours: hours,
                    onOpeningHourChanged: (String? newValue) {
                      setState(() {
                        selectedOpeningHours[6] = newValue!;
                      });
                    },
                    onClosingHourChanged: (String? newValue) {
                      setState(() {
                        selectedClosingHours[6] = newValue!;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //função para mostrar as datas e horarios definidos
  void showCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Calendário selecionado'),
          content: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TableCalendar(
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 10, 16),
                    selectedDayPredicate: (day) => selectedDates.contains(day),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple[500],
                      ),
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red[400],
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
                  ),
                  const Text('Horarios:'),
                  Text(
                      'Segunda-feira: ${selectedOpeningHours[0]} até ${selectedClosingHours[0]}'),
                  Text(
                      'Terça-feira: ${selectedOpeningHours[1]} até ${selectedClosingHours[1]}'),
                  Text(
                      'Quarta-feira: ${selectedOpeningHours[2]} até ${selectedClosingHours[2]}'),
                  Text(
                      'Quinta-feira: ${selectedOpeningHours[3]} até ${selectedClosingHours[3]}'),
                  Text(
                      'Sexta-feira: ${selectedOpeningHours[4]} até ${selectedClosingHours[4]}'),
                  Text(
                      'Sabado: ${selectedOpeningHours[5]} até ${selectedClosingHours[5]}'),
                  Text(
                      'Domingo: ${selectedOpeningHours[6]} até ${selectedClosingHours[6]}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.blueGrey,
              child: TableCalendar(
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                focusedDay: today,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 10, 16),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => selectedDates.contains(day),
                onDaySelected: _onDaySelected,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple[500],
                  ),
                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[400],
                  ),
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green[400],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: configureHours,
                  child: const Text('Definir horários'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => showCalendarDialog(context),
                  child: const Text('Ver'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

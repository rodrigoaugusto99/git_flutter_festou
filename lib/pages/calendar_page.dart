import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime today = DateTime.now();
  Set<DateTime> selectedDates = {};

  //bool isEditing = true;

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      //if (isEditing) {
      if (selectedDates.contains(day)) {
        selectedDates.remove(day);
      } else {
        selectedDates.add(day);
      }
      // }
    });
  }

  String getWeekdayText(int weekday) {
    final weekdays = DateFormat.E().dateSymbols.WEEKDAYS;
    return weekdays[weekday % 7];
  }

  List<String> hours =
      List.generate(24, (index) => (index + 1).toString().padLeft(2, '0'));

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

  void markDatesAsRentable() {
    String selectedOpeningHour2 = '01';
    String selectedClosingHour2 = '24';
    String selectedOpeningHour3 = '01';
    String selectedClosingHour3 = '24';
    String selectedOpeningHour4 = '01';
    String selectedClosingHour4 = '24';
    String selectedOpeningHour5 = '01';
    String selectedClosingHour5 = '24';
    String selectedOpeningHour6 = '01';
    String selectedClosingHour6 = '24';
    String selectedOpeningHour7 = '01';
    String selectedClosingHour7 = '24';
    String selectedOpeningHour8 = '01';
    String selectedClosingHour8 = '24';

    /*setState(() {
      isEditing = false;
    });*/
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              children: [
                const Text(
                  "Configure os horarios",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                myRow(
                  text: 'segunda',
                  selectedOpeningHour: selectedOpeningHour2,
                  selectedClosingHour: selectedClosingHour2,
                  hours: hours,
                  onOpeningHourChanged: (String? newValue) {
                    setState(() {
                      selectedOpeningHour2 = newValue!;
                    });
                  },
                  onClosingHourChanged: (String? newValue) {
                    setState(() {
                      selectedClosingHour2 = newValue!;
                    });
                  },
                ),
                myRow(
                  text: 'terca',
                  selectedOpeningHour: selectedOpeningHour2,
                  selectedClosingHour: selectedClosingHour2,
                  hours: hours,
                  onOpeningHourChanged: (String? newValue) {
                    setState(() {
                      selectedOpeningHour2 = newValue!;
                    });
                  },
                  onClosingHourChanged: (String? newValue) {
                    setState(() {
                      selectedClosingHour2 = newValue!;
                    });
                  },
                ),
                myRow(
                  text: 'quarta',
                  selectedOpeningHour: selectedOpeningHour2,
                  selectedClosingHour: selectedClosingHour2,
                  hours: hours,
                  onOpeningHourChanged: (String? newValue) {
                    setState(() {
                      selectedOpeningHour2 = newValue!;
                    });
                  },
                  onClosingHourChanged: (String? newValue) {
                    setState(() {
                      selectedClosingHour2 = newValue!;
                    });
                  },
                ),
                myRow(
                  text: 'quinta',
                  selectedOpeningHour: selectedOpeningHour2,
                  selectedClosingHour: selectedClosingHour2,
                  hours: hours,
                  onOpeningHourChanged: (String? newValue) {
                    setState(() {
                      selectedOpeningHour2 = newValue!;
                    });
                  },
                  onClosingHourChanged: (String? newValue) {
                    setState(() {
                      selectedClosingHour2 = newValue!;
                    });
                  },
                ),
                myRow(
                  text: 'sexta',
                  selectedOpeningHour: selectedOpeningHour2,
                  selectedClosingHour: selectedClosingHour2,
                  hours: hours,
                  onOpeningHourChanged: (String? newValue) {
                    setState(() {
                      selectedOpeningHour2 = newValue!;
                    });
                  },
                  onClosingHourChanged: (String? newValue) {
                    setState(() {
                      selectedClosingHour2 = newValue!;
                    });
                  },
                ),
                myRow(
                  text: 'sabado',
                  selectedOpeningHour: selectedOpeningHour2,
                  selectedClosingHour: selectedClosingHour2,
                  hours: hours,
                  onOpeningHourChanged: (String? newValue) {
                    setState(() {
                      selectedOpeningHour2 = newValue!;
                    });
                  },
                  onClosingHourChanged: (String? newValue) {
                    setState(() {
                      selectedClosingHour2 = newValue!;
                    });
                  },
                ),
                myRow(
                  text: 'domingo',
                  selectedOpeningHour: selectedOpeningHour2,
                  selectedClosingHour: selectedClosingHour2,
                  hours: hours,
                  onOpeningHourChanged: (String? newValue) {
                    setState(() {
                      selectedOpeningHour2 = newValue!;
                    });
                  },
                  onClosingHourChanged: (String? newValue) {
                    setState(() {
                      selectedClosingHour2 = newValue!;
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  void showCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Calendário selecionado'),
          content: SizedBox(
            width: 400,
            height: 400,
            child: TableCalendar(
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
            /*Text(
              "Selected date(s): ${selectedDates.map((date) => DateFormat('dd/MM/yyyy').format(date)).join(", ")}",
            ),*/
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
                  onPressed: markDatesAsRentable,
                  child: const Text('Definir horários'),
                ),
                /*const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                    });
                  },
                  child: const Text('Editar'),
                ),*/
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => showCalendarDialog(context),
                  child: const Text('Ver'),
                ),
              ],
            ),
            /*const SizedBox(height: 16),
            if (!isEditing)
              const Text(
                "Datas que você marcou como disponíveis:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            if (!isEditing)
              Column(
                children: selectedDates
                    .map((date) => Text(DateFormat('dd/MM/yyyy').format(date)))
                    .toList(),
              ),
            const SizedBox(height: 16),
            */
          ],
        ),
      ),
    );
  }
}

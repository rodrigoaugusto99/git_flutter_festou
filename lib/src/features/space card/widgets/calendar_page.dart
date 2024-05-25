import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class CalendarPage extends StatefulWidget {
  final SpaceModel space;
  const CalendarPage({super.key, required this.space});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDate;

  int? checkInTime;
  int? checkOutTime;

  void onSelectTime(int selectedTime) {
    setState(() {
      if (checkInTime == null) {
        checkInTime = selectedTime;
      } else if (checkOutTime == null) {
        checkOutTime = selectedTime;
      } else {
        checkInTime = selectedTime;
        checkOutTime = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int startHour = int.parse(widget.space.startTime);
    int endHour = int.parse(widget.space.endTime);
    int itemCount = endHour - startHour + 1;
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
          'Calendário',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 30.0, left: 30, right: 30, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selecione uma data',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                        'startTime e endTime desse espaco: ${widget.space.startTime} - ${widget.space.endTime}'),
                    Text('dias disponiveis: ${widget.space.days}'),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: CalendarDatePicker2(
                          config: CalendarDatePicker2Config(
                            disableModePicker: true,
                            daySplashColor: Colors.transparent,
                            selectedDayHighlightColor: Colors.purple[700],
                            weekdayLabels: [
                              'Dom',
                              'Seg',
                              'Ter',
                              'Qua',
                              'Qui',
                              'Sex',
                              'Sab'
                            ],
                            weekdayLabelTextStyle: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                            firstDayOfWeek: 1,
                            controlsHeight: 50,
                            controlsTextStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            dayTextStyle: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                            disabledDayTextStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            centerAlignModePicker: true,
                            useAbbrLabelForMonthModePicker: true,
                            firstDate: DateTime(
                                DateTime.now().year - 2,
                                DateTime.now().month - 1,
                                DateTime.now().day - 5),
                            lastDate: DateTime(
                                DateTime.now().year + 3,
                                DateTime.now().month + 2,
                                DateTime.now().day + 10),
                            selectableDayPredicate: (day) =>
                                !day.difference(DateTime.now()).isNegative,
                          ),
                          value: [_selectedDate],
                          onValueChanged: (dates) {
                            setState(() {
                              _selectedDate = dates.first;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Selecione o horário',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Align(
                      child: Text(
                        'Tempo minimo de locação: 4h',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      '      No dia $_selectedDate:',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: itemCount,
                  itemBuilder: (BuildContext context, int index) {
                    int hour = startHour + index;
                    bool isSelected =
                        (hour == checkInTime) || (hour == checkOutTime);
                    return GestureDetector(
                      onTap: () => onSelectTime(hour),
                      child: CalendarWidget(
                        hour: hour.toString().padLeft(2, '0'),
                        isSelected: isSelected,
                      ),
                    );
                  },
                ),
              ),
              if (checkInTime != null && checkOutTime != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Horario de check-in: ${checkInTime.toString().padLeft(2, '0')}, '
                    'Horario de saida: ${checkOutTime.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: const TextSpan(
                    text: 'Lembre-se: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            'O horário de fim é o momento da entrega do espaço! '
                            'Em caso de atraso serão cobradas horas adicionais e multa por atraso. '
                            'Os valores poderão ser consultados no contrato, na página seguinte.',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.purple, // Cor do botão
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Bordas arredondadas
            ),
          ),
          onPressed: () {
            // Ação do botão
          },
          child: const Text('Prosseguir'),
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final String hour;
  final bool isSelected;
  const CalendarWidget(
      {super.key, required this.hour, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 30,
      width: 70,
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.purple
            : const Color.fromARGB(255, 202, 200, 200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        hour,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

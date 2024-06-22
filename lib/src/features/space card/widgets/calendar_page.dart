import 'dart:developer';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/resumo_reserva_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/summary_data.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:intl/intl.dart';

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
  bool showWarning = false;
  void onSelectTime(int selectedTime) {
    log(selectedTime.toString());
    setState(() {
      if (checkInTime == selectedTime) {
        // Se clicar novamente no mesmo checkInTime, limpar ambos
        checkInTime = null;
        checkOutTime = null;
      } else if (checkOutTime == selectedTime) {
        // Se clicar novamente no mesmo checkOutTime, limpar apenas ele
        checkOutTime = null;
      } else if (checkInTime == null) {
        // Primeira seleção: definir checkInTime
        checkInTime = selectedTime;
      } else if (checkOutTime == null) {
        // Segunda seleção: definir checkOutTime, garantindo que seja maior que checkInTime
        if (selectedTime > checkInTime!) {
          checkOutTime = selectedTime;
        } else {
          checkOutTime = checkInTime;
          checkInTime = selectedTime;
        }
      } else {
        // Limpar e definir novamente checkInTime
        checkInTime = selectedTime;
        checkOutTime = null;
      }

      showWarning = false;

      if (checkInTime != null && checkOutTime != null) {
        // Ajustar checkOutTime temporariamente para a validação
        int adjustedCheckOutTime = checkOutTime!;
        if (checkOutTime! >= 0 && checkOutTime! <= 4) {
          adjustedCheckOutTime += 24;
        }

        if ((adjustedCheckOutTime - checkInTime!) < 4) {
          setState(() {
            showWarning = true;
          });
          return;
        }

        // Garantir que checkOutTime seja sempre maior que checkInTime,
        // considerando a continuidade do dia
        if (checkInTime! >= 1 &&
            checkInTime! <= 4 &&
            checkOutTime! > checkInTime!) {
          // Do nothing, valid case
        } else if (checkOutTime! >= 1 &&
            checkOutTime! <= 4 &&
            checkOutTime! < checkInTime!) {
          // Valid case
        } else if (checkInTime! >= 1 &&
            checkInTime! <= 4 &&
            checkOutTime! <= 4) {
          int temp = checkInTime!;
          checkInTime = checkOutTime;
          checkOutTime = temp;
        } else if (checkOutTime! < checkInTime!) {
          int temp = checkInTime!;
          checkInTime = checkOutTime;
          checkOutTime = temp;
        }

        // Inverter valores se checkInTime for 00, 01, 02, 03 ou 04
        if (checkInTime! >= 0 && checkInTime! <= 4) {
          int temp = checkInTime!;
          checkInTime = checkOutTime;
          checkOutTime = temp;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int startHour = int.parse(widget.space.startTime);
    int endHour = int.parse(widget.space.endTime);
    if (endHour < startHour) {
      endHour += 24;
    }
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
                      height: 47,
                    ),
                    const Text(
                      'Selecione o horário',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showWarning)
                          const Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: 22,
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Tempo mínimo de locação: 4h',
                          style: TextStyle(
                            fontSize: 12,
                            color: !showWarning ? Colors.black : Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (showWarning)
                          const Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: 22,
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      _selectedDate != null
                          ? '      No dia ${DateFormat('d \'de\' MMMM \'de\' y', 'pt_BR').format(_selectedDate!)}:'
                          : '',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 8,
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
                    int hour = (startHour + index) % 24;
                    bool isSelected =
                        (hour == checkInTime) || (hour == checkOutTime);
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () => onSelectTime(hour),
                          child: CalendarWidget(
                            hour: hour.toString().padLeft(2, '0'),
                            isSelected: isSelected,
                          ),
                        ),
                      );
                    }
                    if (index == itemCount - 1) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () => onSelectTime(hour),
                          child: CalendarWidget(
                            hour: hour.toString().padLeft(2, '0'),
                            isSelected: isSelected,
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () => onSelectTime(hour),
                        child: CalendarWidget(
                          hour: hour.toString().padLeft(2, '0'),
                          isSelected: isSelected,
                        ),
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
                    'Horario de check-in: ${checkInTime != null ? checkInTime.toString().padLeft(2, '0') : ''}, '
                    'Horario de saida: ${checkOutTime != null ? ((checkOutTime! % 24).toString().padLeft(2, '0')) : ''}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: const TextSpan(
                    text: 'Lembre-se: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 11),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            'O horário de fim é o momento da entrega do espaço! '
                            'Em caso de atraso serão cobradas horas adicionais e multa por atraso. '
                            'Os valores poderão ser consultados no contrato, na página seguinte.',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: GestureDetector(
          onTap: () {
            if (_selectedDate == null ||
                checkInTime == null ||
                checkOutTime == null) {
              log('ha variaveis nulas');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Selecione uma data e horarios')));
              return;
            }

            // Verificação com ajuste temporário para checkOutTime
            int adjustedCheckOutTime = checkOutTime!;
            if (checkOutTime! >= 0 && checkOutTime! <= 4) {
              adjustedCheckOutTime += 24;
            }

            if ((adjustedCheckOutTime - checkInTime!) < 4) {
              setState(() {
                showWarning = true;
              });
              return;
            }

            SummaryData summaryData = SummaryData(
              dataAtual: null,
              selectedDate: _selectedDate!,
              selectedFinalDate: null, //todo: arrumar
              spaceModel: widget.space,
              checkInTime: checkInTime!,
              checkOutTime: checkOutTime!,

              totalHours: null,
              valorTotalDasHoras: null,
              valorDaTaxaConcierge: null,

              valorTotalAPagar: null,
              valorDaMultaPorHoraExtrapolada: null,
              nomeDoCliente: null,
              cpfDoCliente: null,
              nomeDoLocador: null,
              cpfDoLocador: null,
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResumoReservaPage(
                  summaryData: summaryData,
                  cupomModel: null,
                  html: null,
                ),
              ),
            );
          },
          child: Container(
              alignment: Alignment.center,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff9747FF),
                    Color(0xff44300b1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Text(
                'Prosseguir',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              )),
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
      width: 74,
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xff9747FF)
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

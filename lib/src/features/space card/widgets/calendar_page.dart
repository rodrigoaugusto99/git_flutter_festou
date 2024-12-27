import 'dart:developer';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/resumo_reserva_page.dart';
import 'package:git_flutter_festou/src/features/space%20card/widgets/summary_data.dart';
import 'package:git_flutter_festou/src/models/reservation_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:git_flutter_festou/src/services/reserva_service.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  final SpaceModel space;

  const CalendarPage({super.key, required this.space});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDate;
  int? checkInTime;
  int? checkOutTime;
  bool showWarning = false;
  List<ReservationModel> reservasDoEspaco = [];

  @override
  void initState() {
    fetchReservas();
    super.initState();
  }

  void fetchReservas() async {
    reservasDoEspaco =
        await ReservaService().getReservationsBySpaceId(widget.space.spaceId);
    setState(() {});
  }

  Hours? _getDayHours(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return widget.space.days.monday;
      case DateTime.tuesday:
        return widget.space.days.tuesday;
      case DateTime.wednesday:
        return widget.space.days.wednesday;
      case DateTime.thursday:
        return widget.space.days.thursday;
      case DateTime.friday:
        return widget.space.days.friday;
      case DateTime.saturday:
        return widget.space.days.saturday;
      case DateTime.sunday:
        return widget.space.days.sunday;
      default:
        return null;
    }
  }

  bool _isDateSelectable(DateTime day) {
    bool hasAnyDayRestriction = widget.space.days.monday != null ||
        widget.space.days.tuesday != null ||
        widget.space.days.wednesday != null ||
        widget.space.days.thursday != null ||
        widget.space.days.friday != null ||
        widget.space.days.saturday != null ||
        widget.space.days.sunday != null;

    if (!hasAnyDayRestriction) {
      return !day.difference(DateTime.now()).isNegative;
    }

    Hours? dayHours = _getDayHours(day);
    return dayHours != null && !day.difference(DateTime.now()).isNegative;
  }

  void onSelectTime(int selectedTime, {required bool isCheckIn}) {
    setState(() {
      if (isCheckIn) {
        checkInTime = selectedTime;
        checkOutTime = null;
      } else {
        if (checkInTime != null) {
          int adjustedCheckInTime = checkInTime!;
          if (selectedTime < adjustedCheckInTime) {
            selectedTime += 24;
          }
          if (selectedTime >= adjustedCheckInTime + 4) {
            checkOutTime = selectedTime % 24;
          }
        }
      }
    });
  }

  List<int> _getUnavailableHours() {
    if (_selectedDate == null) return [];

    final List<int> unavailableHours = [];

    // Função auxiliar para obter a data em string no mesmo formato das reservas
    String getDateString(DateTime date) {
      return date.toString();
    }

    // Obtém as datas adjacentes
    final previousDate = _selectedDate!.subtract(const Duration(days: 1));
    final nextDate = _selectedDate!.add(const Duration(days: 1));

    // Verifica reservas do dia anterior
    for (var reservation in reservasDoEspaco) {
      if (reservation.selectedDate == getDateString(previousDate)) {
        // Se a reserva termina tarde no dia anterior, afeta o início do dia atual
        if (reservation.checkOutTime >= 20) {
          // termina após 20:00
          // Adiciona hora de limpeza (primeira hora do dia atual)
          unavailableHours.add(0);
        }
      }
    }

    // Verifica reservas do dia atual
    for (var reservation in reservasDoEspaco) {
      if (reservation.selectedDate == getDateString(_selectedDate!)) {
        // Adiciona o horário de limpeza antes da reserva
        unavailableHours.add((reservation.checkInTime - 1) % 24);

        // Adiciona os horários da reserva
        for (int i = reservation.checkInTime;
            i < reservation.checkOutTime;
            i++) {
          unavailableHours.add(i % 24);
        }

        // Adiciona o horário de limpeza depois da reserva
        unavailableHours.add(reservation.checkOutTime % 24);

        // Adiciona horários indisponíveis devido à regra das 4 horas mínimas
        // Para horários antes da reserva
        for (int i = 1; i <= 4; i++) {
          unavailableHours.add((reservation.checkInTime - 1 - i) % 24);
        }
      }
    }

    // Verifica reservas do dia seguinte
    for (var reservation in reservasDoEspaco) {
      if (reservation.selectedDate == getDateString(nextDate)) {
        // Se a reserva começa cedo no dia seguinte, afeta o fim do dia atual
        if (reservation.checkInTime <= 4) {
          // começa antes das 4:00
          // Adiciona hora de limpeza (última hora do dia atual)
          unavailableHours.add(23);

          // Adiciona as 4 horas mínimas antes da limpeza
          for (int i = 1; i <= 4; i++) {
            unavailableHours.add(23 - i);
          }
        }
      }
    }

    // Remove duplicatas e ordena os horários
    return unavailableHours.toSet().toList()..sort();
  }

  // List<int> _getUnavailableCheckOutHours() {
  //   if (_selectedDate == null) return [];

  //   final List<int> unavailableCheckOutHours = [];

  //   // Função auxiliar para obter a data em string no mesmo formato das reservas
  //   String getDateString(DateTime date) {
  //     return date.toString();
  //   }

  //   // Obtém a data do dia seguinte
  //   final nextDate = _selectedDate!.add(const Duration(days: 1));

  //   // Verifica reservas do dia atual
  //   for (var reservation in reservasDoEspaco) {
  //     if (reservation.selectedDate == getDateString(_selectedDate!)) {
  //       // Adiciona os horários da reserva no dia atual
  //       for (int i = reservation.checkInTime;
  //           i < reservation.checkOutTime;
  //           i++) {
  //         unavailableCheckOutHours.add(i % 24);
  //       }
  //     }
  //   }

  //   // Verifica reservas do dia seguinte
  //   for (var reservation in reservasDoEspaco) {
  //     if (reservation.selectedDate == getDateString(nextDate)) {
  //       // Adiciona os horários da reserva no dia seguinte
  //       for (int i = reservation.checkInTime;
  //           i < reservation.checkOutTime;
  //           i++) {
  //         unavailableCheckOutHours.add(i % 24);
  //       }
  //     }
  //   }

  //   // Remove duplicatas e ordena os horários
  //   return unavailableCheckOutHours.toSet().toList()..sort();
  // }

  Map<String, List<int>> _getUnavailableCheckOutHours() {
    if (_selectedDate == null) return {'currentDay': [], 'nextDay': []};

    final List<int> unavailableCurrentDayHours = [];
    final List<int> unavailableNextDayHours = [];

    String getDateString(DateTime date) => date.toString();

    final nextDate = _selectedDate!.add(const Duration(days: 1));

    for (var reservation in reservasDoEspaco) {
      if (reservation.selectedDate == getDateString(_selectedDate!)) {
        for (int i = reservation.checkInTime;
            i < reservation.checkOutTime;
            i++) {
          unavailableCurrentDayHours.add(i % 24);
        }
      }
      if (reservation.selectedDate == getDateString(nextDate)) {
        for (int i = reservation.checkInTime;
            i < reservation.checkOutTime;
            i++) {
          unavailableNextDayHours.add(i % 24);
        }
      }
    }

    return {
      'currentDay': unavailableCurrentDayHours.toSet().toList()..sort(),
      'nextDay': unavailableNextDayHours.toSet().toList()..sort(),
    };
  }

  Widget _buildTimeSelectionRowCheckIn({
    required int startHour,
    required int endHour,
    required List<int> unavailableHours,
  }) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: endHour > startHour
            ? endHour - startHour + 1
            : (24 - startHour + endHour + 1),
        itemBuilder: (context, index) {
          final int hour = (startHour + index) % 24;

          final bool isUnavailable = unavailableHours.contains(hour);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isUnavailable)
                  const Text(
                    'Indisponível',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                GestureDetector(
                  onTap: isUnavailable
                      ? null
                      : () => onSelectTime(hour, isCheckIn: true),
                  child: CalendarWidget(
                    hour: '${hour.toString().padLeft(2, '0')}:00',
                    isSelected: hour == checkInTime,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget _buildTimeSelectionRowCheckOut({
  //   required int startHour,
  //   required int endHour,
  //   required List<int> unavailableHours,
  // }) {
  //   bool reachedLimit = false;
  //   bool reachedNextDay = false;
  //   final itemCount = endHour > startHour
  //       ? endHour - startHour + 1
  //       : (24 - startHour + endHour + 1);

  //   return SizedBox(
  //     height: 50,
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Row(
  //         children: List.generate(itemCount, (index) => index)
  //             .asMap()
  //             .entries
  //             .map((entry) {
  //           final int index = entry.key;
  //           final int hour = (startHour + index) % 24;

  //           final bool isUnavailable = unavailableHours.contains(hour);

  //           final bool isNextDay = (startHour + index) >= 24;
  //           if (isUnavailable) {
  //             reachedLimit = true;
  //           }

  //           if (isNextDay) {
  //             reachedNextDay = true;
  //           }

  //           return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 10),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 if (reachedLimit) ...[
  //                   const Text(
  //                     'Indisponível',
  //                     style: TextStyle(fontSize: 12, color: Colors.red),
  //                   ),
  //                 ] else if (reachedNextDay && !reachedLimit) ...[
  //                   const Text(
  //                     'Dia seguinte',
  //                     style: TextStyle(fontSize: 12, color: Colors.grey),
  //                   ),
  //                 ] else if (reachedNextDay) ...[
  //                   const Text(
  //                     'Dia seguinte',
  //                     style: TextStyle(fontSize: 12, color: Colors.grey),
  //                   ),
  //                 ],
  //                 GestureDetector(
  //                   onTap: isUnavailable
  //                       ? null
  //                       : () => onSelectTime(hour, isCheckIn: false),
  //                   child: CalendarWidget(
  //                     hour: '${hour.toString().padLeft(2, '0')}:59',
  //                     isSelected: hour == checkOutTime,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }).toList(),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTimeSelectionRowCheckOut({
    required int startHour,
    required int endHour,
    required List<int> unavailableHoursCurrentDay,
    required List<int> unavailableHoursNextDay,
  }) {
    bool reachedLimit = false;

    final itemCount = endHour > startHour
        ? endHour - startHour + 1
        : (24 - startHour + endHour + 1);

    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(itemCount, (index) => index)
              .asMap()
              .entries
              .map((entry) {
            log(startHour.toString());
            final int index = entry.key;
            final int hour = (startHour + index) % 24;

            // Corrigida a lógica para identificar "dia seguinte"
            final bool isNextDay;
            if (startHour >= 0 && startHour <= 3) {
              // Para startHour de 0 a 3, considera como "Dia seguinte" se hour < startHour
              isNextDay = true;
            } else {
              // Lógica padrão para outros horários
              isNextDay = (startHour + index) >= 24;
            }

            // Determina a lista de indisponibilidade com base no dia
            final bool isUnavailable = reachedLimit ||
                (isNextDay
                    ? unavailableHoursNextDay.contains(hour)
                    : unavailableHoursCurrentDay.contains(hour));

            // Marca como indisponível se já tiver atingido o limite
            if (isUnavailable) {
              reachedLimit = true;
            }

            // Exibe "Dia seguinte" no início de cada hora do próximo dia
            bool showNextDayLabel = isNextDay && !isUnavailable;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (showNextDayLabel)
                    const Text(
                      'Dia seguinte',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  if (isUnavailable)
                    const Text(
                      'Indisponível',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  GestureDetector(
                    onTap: isUnavailable
                        ? null
                        : () => onSelectTime(hour, isCheckIn: false),
                    child: CalendarWidget(
                      hour: '${hour.toString().padLeft(2, '0')}:59',
                      isSelected: hour == checkOutTime,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Widget _buildTimeSelection() {
  //   if (_selectedDate == null) return const SizedBox();

  //   final dayHours = _getDayHours(_selectedDate!);
  //   if (dayHours == null) return const SizedBox();

  //   final startHour = int.parse(dayHours.from.split(':')[0]);
  //   final endHour = int.parse(dayHours.to.split(':')[0]);
  //   final unavailableHours = _getUnavailableHours();
  //   final unavailableHoursCheckout = _getUnavailableCheckOutHours();

  //   return Column(
  //     children: [
  //       _buildTimeSelectionRowCheckIn(
  //         startHour: startHour,
  //         endHour: endHour,
  //         unavailableHours: unavailableHours,
  //       ),
  //       const SizedBox(height: 10),
  //       if (checkInTime != null)
  //         _buildTimeSelectionRowCheckOut(
  //           startHour: (checkInTime! + 4) % 24,
  //           endHour: (checkInTime! + 24) % 24,
  //           unavailableHours: unavailableHoursCheckout,
  //         ),
  //     ],
  //   );
  // }
  Widget _buildTimeSelection() {
    if (_selectedDate == null) return const SizedBox();

    final dayHours = _getDayHours(_selectedDate!);
    if (dayHours == null) return const SizedBox();

    final startHour = int.parse(dayHours.from.split(':')[0]);
    final endHour = int.parse(dayHours.to.split(':')[0]);
    final unavailableHours = _getUnavailableHours();
    final unavailableHoursCheckout = _getUnavailableCheckOutHours();

    return Column(
      children: [
        _buildTimeSelectionRowCheckIn(
          startHour: startHour,
          endHour: endHour,
          unavailableHours: unavailableHours,
        ),
        const SizedBox(height: 10),
        if (checkInTime != null)
          _buildTimeSelectionRowCheckOut(
            startHour: (checkInTime! + 4) % 24,
            endHour: (checkInTime! + 24) % 24,
            unavailableHoursCurrentDay: unavailableHoursCheckout['currentDay']!,
            unavailableHoursNextDay: unavailableHoursCheckout['nextDay']!,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 30,
                  right: 30,
                  bottom: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selecione uma data',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildCalendarPicker(),
                    const SizedBox(height: 47),
                    _buildTimeSelectionHeader(),
                    if (_selectedDate != null)
                      Text(
                        '      No dia ${DateFormat('d \'de\' MMMM \'de\' y', 'pt_BR').format(_selectedDate!)}:',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              _buildTimeSelection(),
              if (checkInTime != null && checkOutTime != null)
                _buildSelectedTimeDisplay(),
              _buildReminderText(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: CalendarDatePicker2(
          config: CalendarDatePicker2Config(
            disableModePicker: true,
            daySplashColor: Colors.transparent,
            selectedDayHighlightColor: Colors.purple[700],
            weekdayLabels: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'],
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
              DateTime.now().day - 5,
            ),
            lastDate: DateTime(
              DateTime.now().year + 3,
              DateTime.now().month + 2,
              DateTime.now().day + 10,
            ),
            selectableDayPredicate: _isDateSelectable,
          ),
          value: [_selectedDate],
          onValueChanged: (dates) {
            setState(() {
              _selectedDate = dates.first;
              checkInTime = null;
              checkOutTime = null;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTimeSelectionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione o horário',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showWarning)
              const Icon(Icons.warning, color: Colors.red, size: 22),
            const SizedBox(width: 5),
            Text(
              'Tempo mínimo de locação: 4h',
              style: TextStyle(
                fontSize: 12,
                color: !showWarning ? Colors.black : Colors.red,
              ),
            ),
            const SizedBox(width: 5),
            if (showWarning)
              const Icon(Icons.warning, color: Colors.red, size: 22),
          ],
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildSelectedTimeDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        'Horario de check-in: ${checkInTime.toString().padLeft(2, '0')}, '
        'Horario de saida: ${(checkOutTime! % 24).toString().padLeft(2, '0')}',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildReminderText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: RichText(
        textAlign: TextAlign.start,
        text: const TextSpan(
          text: 'Lembre-se: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 11,
          ),
          children: [
            TextSpan(
              text: 'O horário de fim é o momento da entrega do espaço! '
                  'Em caso de atraso serão cobradas horas adicionais e multa por atraso. '
                  'Os valores poderão ser consultados no contrato, na página seguinte.',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final String hour;
  final bool isSelected;
  final bool isAvailable;
  const CalendarWidget({
    super.key,
    required this.hour,
    required this.isSelected,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 30,
      width: 74,
      decoration: BoxDecoration(
        color: isAvailable
            ? isSelected
                ? const Color(0xff9747FF)
                : const Color.fromARGB(255, 202, 200, 200)
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        hour,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isAvailable ? Colors.white : Colors.grey[400],
        ),
      ),
    );
  }
}
/*
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
 */



/*
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
 */
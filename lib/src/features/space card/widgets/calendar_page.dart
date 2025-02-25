import 'dart:developer' as dev;
import 'dart:math';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/features/space%20card/widgets/resumo_reserva_page.dart';
import 'package:festou/src/features/space%20card/widgets/summary_data.dart';
import 'package:festou/src/models/reservation_model.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:festou/src/services/reserva_service.dart';
import 'package:lottie/lottie.dart';

class CalendarPage extends StatefulWidget {
  final SpaceModel space;
  final bool isIndisponibilizar;

  const CalendarPage({
    super.key,
    required this.space,
    this.isIndisponibilizar = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDate;
  int? checkInTime;
  int? checkOutTime;
  bool showWarning = false;
  List<ReservationModel> reservasDoEspaco = [];
  bool _showAnimation = true;

  @override
  void initState() {
    fetchReservas();
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showAnimation = false;
      });
    });
  }

  void fetchReservas() async {
    reservasDoEspaco = await ReservaService()
        .getReservationsBySpaceIdForCalendar(widget.space.spaceId);
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
    // Verifica se todos os dias da semana estão como null
    bool allDaysAreNull = widget.space.days.monday == null &&
        widget.space.days.tuesday == null &&
        widget.space.days.wednesday == null &&
        widget.space.days.thursday == null &&
        widget.space.days.friday == null &&
        widget.space.days.saturday == null &&
        widget.space.days.sunday == null;

    // Se todos os dias forem null, nenhum dia é selecionável
    if (allDaysAreNull) {
      return false;
    }

    // Verifica se o dia específico tem horários disponíveis
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
          if (widget.isIndisponibilizar) {
            checkOutTime = selectedTime % 24;
            return;
          }
          if (selectedTime >= adjustedCheckInTime + 3) {
            checkOutTime = selectedTime % 24;
          }
        }
      }
    });
  }

  // Função auxiliar para obter a data em string no mesmo formato das reservas
  String getDateString(DateTime date) {
    final data = date.toString();
    return data;
  }

  List<int> _getUnavailableHours(isIndisponibilizar) {
    if (_selectedDate == null) return [];

    final List<int> unavailableHours = [];

    // Obtém as datas adjacentes
    final previousDate = _selectedDate!.subtract(const Duration(days: 1));
    final nextDate = _selectedDate!.add(const Duration(days: 1));

    // Verifica reservas do dia anterior
    for (var reservation in reservasDoEspaco) {
      if (reservation.selectedDate.toDate().toString() ==
          getDateString(previousDate)) {
        // Caso 1: Contrato termina exatamente às 23:59 do dia anterior
        if (reservation.checkOutTime == 23) {
          unavailableHours
              .add(0); // Adiciona a primeira hora do dia atual (00:00 - 00:59)
        }
        // Caso 2: Contrato ultrapassa a meia-noite e continua no dia atual
        else if (reservation.checkOutTime < reservation.checkInTime) {
          for (int i = 0; i <= reservation.checkOutTime; i++) {
            unavailableHours.add(
                i); // Adiciona as horas iniciais do dia atual até o horário de término
          }
        }
      }
    }

    // Verifica reservas do dia atual
    for (var reservation in reservasDoEspaco) {
      if (reservation.selectedDate.toDate().toString() ==
          getDateString(_selectedDate!)) {
        if (reservation.checkOutTime <= reservation.checkInTime) {
          // Horas do dia atual: de checkInTime até 23h
          for (int i = reservation.checkInTime; i <= 23; i++) {
            unavailableHours.add(i);
          }
        } else {
          // Caso o contrato esteja dentro do mesmo dia
          for (int i = reservation.checkInTime;
              i <= reservation.checkOutTime;
              i++) {
            unavailableHours.add(i);
          }
        }

        // Adiciona horários indisponíveis devido à regra das 4h mínimas e 1h limpeza
        if (reservation.checkInTime != 0 && !isIndisponibilizar) {
          if (reservation.checkInTime <= 3) {
            // Indisponibiliza todas as horas anteriores do dia
            for (int hour = 0; hour <= reservation.checkInTime - 1; hour++) {
              unavailableHours.add(hour);
            }
          } else {
            // Indisponibiliza apenas as 5 horas anteriores
            for (int i = 1; i <= 4; i++) {
              int hour = (reservation.checkInTime - i) % 24;
              unavailableHours.add(hour);
            }
          }
        }
      }
    }

    // Verifica reservas do dia seguinte ou contratos que ultrapassam a meia-noite
    for (var reservation in reservasDoEspaco) {
      // Verifica contratos do próximo dia
      if (reservation.selectedDate.toDate().toString() ==
          getDateString(nextDate)) {
        if (reservation.checkInTime <= 4 && !isIndisponibilizar) {
          int value = 4 - (reservation.checkInTime % 24);
          for (int i = 1; i <= value; i++) {
            unavailableHours.add(24 - i);
          }
        }
      }
    }

    // Remove duplicatas e ordena os horários
    return unavailableHours.toSet().toList()..sort();
  }

  Map<String, List<int>> _getUnavailableCheckOutHours(isIndisponibilizar) {
    if (_selectedDate == null) return {'currentDay': [], 'nextDay': []};

    final List<int> unavailableCurrentDayHours = [];
    final List<int> unavailableNextDayHours = [];

    String getDateString(DateTime date) => date.toString();

    final nextDate = _selectedDate!.add(const Duration(days: 1));

    // Verifica reservas do dia atual
    for (var reservation in reservasDoEspaco) {
      if (reservation.selectedDate.toDate().toString() ==
          getDateString(_selectedDate!)) {
        // Caso o contrato ultrapasse a meia-noite
        if (reservation.checkOutTime <= reservation.checkInTime) {
          // Horas do dia atual: de checkInTime até 23h
          for (int i = reservation.checkInTime; i <= 23; i++) {
            unavailableCurrentDayHours.add(i);
          }
          // Horas do dia seguinte: de 0h até checkOutTime
          for (int i = 0; i <= reservation.checkOutTime; i++) {
            unavailableNextDayHours.add(i);
          }
        } else {
          // Caso o contrato esteja dentro do mesmo dia
          for (int i = reservation.checkInTime;
              i <= reservation.checkOutTime;
              i++) {
            unavailableCurrentDayHours.add(i);
          }
        }

        // Adiciona o horário de limpeza depois da reserva
        if (reservation.checkOutTime < 23 &&
            (reservation.indisponibilizado == null ||
                reservation.indisponibilizado == false)) {
          unavailableNextDayHours.add(reservation.checkOutTime + 1 % 24);
        }

        // Adiciona horários indisponíveis devido à regra de 1h anterior
        if (reservation.checkInTime != 0 && !isIndisponibilizar) {
          int hour = reservation.checkInTime - 1;
          unavailableCurrentDayHours.add(hour % 24);
        }
      }
    }

    // Verifica reservas do dia seguinte
    for (var reservation in reservasDoEspaco) {
      if (reservation.selectedDate.toDate().toString() ==
          getDateString(nextDate)) {
        if (reservation.checkInTime == 0 && !isIndisponibilizar) {
          unavailableCurrentDayHours.add(23);
        }
        for (int i = reservation.checkInTime;
            i <= reservation.checkOutTime;
            i++) {
          unavailableNextDayHours.add(i % 24);
        }
      }

      // Verifica contratos do dia atual que ultrapassam a meia-noite
      if (reservation.selectedDate.toDate().toString() ==
          getDateString(_selectedDate!)) {
        // Se o contrato termina no dia seguinte, bloqueia as horas do dia seguinte até o horário de término
        if (reservation.checkOutTime < reservation.checkInTime) {
          for (int hour = 0; hour <= reservation.checkOutTime; hour++) {
            unavailableNextDayHours.add(hour);
          }
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

  Widget _buildTimeSelectionRowCheckOut({
    required int startHour,
    required int endHour,
    required List<int> unavailableHoursCurrentDay,
    required List<int> unavailableHoursNextDay,
    required bool show24h,
    required String checkoutStringEndHour,
  }) {
    bool reachedLimit = false;

    final itemCount = endHour > startHour
        ? endHour - startHour + 1
        : show24h
            ? (24 - startHour + endHour + 1)
            : endHour - startHour + 1;

    dev.log('itemCount: $itemCount');
    dev.log('show24h: $show24h');

    return SizedBox(
      height: 65,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(itemCount, (index) {
            final int hour = (startHour + index) % 24;

            final bool isNextDay = hour < checkInTime!;
            //final bool isNextDay = (startHour + index) >= 24;

            // Define se o horário é indisponível, considerando o dia atual ou o seguinte
            final bool isUnavailable = reachedLimit ||
                (isNextDay
                    ? unavailableHoursNextDay.contains(hour)
                    : unavailableHoursCurrentDay.contains(hour));

            // Se o horário for indisponível, marque para não continuar exibindo
            if (isUnavailable) {
              reachedLimit = true;
            }

            // Exibe a tag "Dia seguinte" apenas se o horário realmente pertence ao próximo dia
            bool showNextDayLabel = isNextDay && hour >= 0;

            // Formata a string do horário
            String hourString = '${hour.toString().padLeft(2, '0')}:59';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 17,
                      child: (!isUnavailable && showNextDayLabel)
                          ? const Text(
                              'Dia seguinte',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              textAlign: TextAlign.center,
                            )
                          : (isUnavailable
                              ? const Text(
                                  'Indisponível',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                  textAlign: TextAlign.center,
                                )
                              : const SizedBox.shrink()),
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
                    SizedBox(
                      height: 16,
                      child: (isUnavailable && showNextDayLabel)
                          ? const Text(
                              'Dia seguinte',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTimeSelection() {
    if (_selectedDate == null) return const SizedBox();

    final dayHours = _getDayHours(_selectedDate!);
    if (dayHours == null) return const SizedBox();

    final startHour = int.parse(dayHours.from.split(':')[0]);
    final endHour = int.parse(dayHours.to.split(':')[0]);

    // Horários do próximo dia
    final nextDayHours =
        _getDayHours(_selectedDate!.add(const Duration(days: 1)));

    final unavailableHours = _getUnavailableHours(widget.isIndisponibilizar);
    final unavailableHoursCheckout =
        _getUnavailableCheckOutHours(widget.isIndisponibilizar);

    bool show24h = true;

    // Inicializa com os horários do dia atual
    int checkinEndHour = endHour;
    int checkoutEndHour = endHour;

    // Se o checkInTime for definido
    if (checkInTime != null) {
      // Se o horário de check-out ultrapassa o dia atual, usa o horário do próximo dia
      if (nextDayHours != null && (checkInTime! >= endHour)) {
        checkoutEndHour = int.parse(nextDayHours.to.split(':')[0]);
      } else {
        checkoutEndHour = (checkInTime! + 24) % 24;
      }

      if (endHour != 23) {
        checkoutEndHour = endHour;
        show24h = false;
      }
    }

    String checkoutStringEndHour = '';

    if (endHour != 23) {
      checkinEndHour = endHour - 3;
      if (checkinEndHour < 0) {
        checkinEndHour = checkinEndHour + 24;
      }
    } else {
      //se o horario final for 23, averiguar se pode mostrar o 23 mesmo
      //final nextDayHours = _getDayHours(_selectedDate!.add(const Duration(days: 1)));
      if (nextDayHours == null || nextDayHours.from != '00:00') {
        checkinEndHour = endHour - 3;
        if (checkinEndHour < 0) {
          checkinEndHour = checkinEndHour + 24;
        }
        checkoutEndHour = endHour;
        show24h = false;
      } else {
        checkoutEndHour = checkoutEndHour;
      }
    }

    dev.log('checkinEndHour: $checkinEndHour');
    dev.log('checkoutEndHour: $checkoutEndHour');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 40),
          child: Text(
            'Início em:',
            style: TextStyle(fontSize: 12),
          ),
        ),
        _buildTimeSelectionRowCheckIn(
          startHour: startHour,
          endHour: checkinEndHour,
          unavailableHours: unavailableHours,
        ),
        const SizedBox(height: 10),
        if (checkInTime != null) ...[
          const Padding(
            padding: EdgeInsets.only(left: 40),
            child: Text(
              'Fim em:',
              style: TextStyle(fontSize: 12),
            ),
          ),
          _buildTimeSelectionRowCheckOut(
            checkoutStringEndHour: checkoutStringEndHour,
            show24h: show24h,
            startHour: widget.isIndisponibilizar
                ? checkInTime! % 24
                : (checkInTime! + 3) % 24,
            endHour: checkoutEndHour,
            unavailableHoursCurrentDay: unavailableHoursCheckout['currentDay']!,
            unavailableHoursNextDay: unavailableHoursCheckout['nextDay']!,
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: widget.isIndisponibilizar
          ? GestureDetector(
              onTap: () async {
                try {
                  await ReservaService().indisponibilizar(
                    checkInTime: checkInTime!,
                    selectedDate: Timestamp.fromDate(_selectedDate!),
                    spaceId: widget.space.spaceId,
                    checkOutTime: checkOutTime!,
                  );
                  Navigator.pop(context);
                  Messages.showInfo(
                      'Você indisponibilizou este horário', context);
                } on Exception catch (e) {
                  dev.log(e.toString());
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                    alignment: Alignment.center,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff9747FF),
                          // ignore: use_full_hex_values_for_flutter_colors
                          Color(0xff44300b1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Text(
                      'Indisponibilizar',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  if (_selectedDate == null ||
                      checkInTime == null ||
                      checkOutTime == null) {
                    dev.log('ha variaveis nulas');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Selecione uma data e horarios')));
                    return;
                  }

                  // Verificação com ajuste temporário para checkOutTime
                  int adjustedCheckOutTime = checkOutTime!;
                  //if (checkOutTime! >= 0 && checkOutTime! <= 4) {
                  adjustedCheckOutTime += 24;
                  //}

                  if ((adjustedCheckOutTime - checkInTime!) < 3) {
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
                          // ignore: use_full_hex_values_for_flutter_colors
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                        // if (_selectedDate != null)
                        //   Text(
                        //     '      No dia ${DateFormat('d \'de\' MMMM \'de\' y', 'pt_BR').format(_selectedDate!)}:',
                        //     style: const TextStyle(fontWeight: FontWeight.w500),
                        //   ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  _buildTimeSelection(),
                  if (checkInTime != null && checkOutTime != null)
                    //_buildSelectedTimeDisplay(),
                    _buildReminderText(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          if (_showAnimation)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Lottie.asset(
                    'lib/assets/animations/confetti_explosion.json',
                    width: 500,
                    height: 500,
                    repeat: false,
                  ),
                ),
              ),
            ),
        ],
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
        if (widget.isIndisponibilizar)
          const Text(
            'Selecione o horário para indisponibilizar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        if (!widget.isIndisponibilizar)
          const Text(
            'Selecione o horário',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 14),
        if (!widget.isIndisponibilizar)
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

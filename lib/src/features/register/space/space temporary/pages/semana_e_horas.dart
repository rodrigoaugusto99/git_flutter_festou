import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Festou/src/core/ui/helpers/messages.dart';
import 'package:Festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:Festou/src/features/register/space/space%20temporary/pages/revisao.dart';
import 'package:Festou/src/helpers/helpers.dart';
import 'package:Festou/src/helpers/keys.dart';
import 'package:Festou/src/models/space_model.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class TimeSelector extends StatelessWidget {
  final List<String> times;

  const TimeSelector({super.key, required this.times});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 100,
      ),
      child: Dialog(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          height: 400,
          child: ListView.builder(
            itemCount: times.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context, times[index]);
                },
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(times[index])),
              );
            },
          ),
        ),
      ),
    );
  }
}

List<String> generateHourlyTimes() {
  List<String> times = [];
  for (int hour = 0; hour < 24; hour++) {
    String formattedHour = hour.toString().padLeft(2, '0');
    times.add('$formattedHour:00');
  }
  return times;
}

List<String> generateHourly59Times() {
  List<String> times = [];
  for (int hour = 0; hour < 24; hour++) {
    String formattedHour = hour.toString().padLeft(2, '0');
    times.add('$formattedHour:59');
  }
  return times;
}

class TimePickerForDay extends StatefulWidget {
  final String dayOfWeek;
  final Function(String day, String? from, String? to) onSetHours;
  final bool isFilled;
  final bool isFirst;

  const TimePickerForDay({
    super.key,
    required this.dayOfWeek,
    required this.onSetHours,
    this.isFilled = false,
    this.isFirst = false,
  });

  @override
  State<TimePickerForDay> createState() => _TimePickerForDayState();
}

class _TimePickerForDayState extends State<TimePickerForDay> {
  String? fromTime;
  String? toTime;

  // void _setFromTime(DateTime dateTime) {
  //   setState(() {
  //     fromTime = dateTime;
  //   });
  //   //if (fromTime != null && toTime != null) {
  //   widget.onSetHours(
  //     widget.dayOfWeek,
  //     fromTime != null ? _formatTime(fromTime!) : '00:00',
  //     toTime != null ? _formatTime(toTime!) : '23:59',
  //   );
  // }

  // void _setToTime(DateTime dateTime) {
  //   setState(() {
  //     toTime = dateTime;
  //   });
  //   // if (fromTime != null && toTime != null) {
  //   widget.onSetHours(
  //     widget.dayOfWeek,
  //     fromTime != null ? _formatTime(fromTime!) : '00:00',
  //     toTime != null ? _formatTime(toTime!) : '23:59',
  //   );
  // }

  void _setFromTime(String date) {
    setState(() {
      fromTime = date;
    });
    //if (fromTime != null && toTime != null) {
    widget.onSetHours(
      widget.dayOfWeek,
      fromTime ?? '00:00',
      toTime ?? '23:59',
    );
  }

  void _setToTime(String date) {
    setState(() {
      toTime = date;
    });
    // if (fromTime != null && toTime != null) {
    widget.onSetHours(
      widget.dayOfWeek,
      fromTime ?? '00:00',
      toTime ?? '23:59',
    );
  }

  // String _formatTime(DateTime time) {
  //   return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  // }

  @override
  Widget build(BuildContext context) {
    // DateTime fromtime = fromTime ??
    //     DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);

    // DateTime totime = toTime ??
    //     DateTime.now()
    //         .copyWith(hour: 23, minute: 59, second: 0, millisecond: 0);

    String fromtime = fromTime ?? '00:00';

    String totime = toTime ?? '23:59';
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                AbsorbPointer(
                  child: SizedBox(
                    height: 30,
                    width: 98,
                    child: TimePickerSpinnerPopUp(
                      iconSize: 0,

                      paddingHorizontalOverlay: 50,
                      enable: widget.isFilled,
                      mode: CupertinoDatePickerMode.time,
                      //initTime: fromTime ?? DateTime.now(),
                      // initTime: fromtime,
                      barrierColor: Colors.black12,
                      // minuteInterval: 60,
                      padding: const EdgeInsets.all(12),
                      cancelText: 'Cancel',
                      confirmText: 'OK',
                      pressType: PressType.singlePress,
                      timeFormat: 'mm',
                      //onChange: _setFromTime,
                      radius: 30,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final x = await showDialog(
                      context: context,
                      builder: (context) =>
                          TimeSelector(times: generateHourlyTimes()),
                    );
                    if (x != null) {
                      _setFromTime(x);
                    }
                  },
                  child: decContainer(
                    color: Colors.white,
                    borderColor: Colors.white,
                    borderWidth: 4,
                    height: 30,
                    width: 98,
                    radius: 10,
                  ),
                ),
                if (!widget.isFilled) ...[
                  decContainer(
                    color: const Color(0xffBABABA),
                    height: 30,
                    width: 98,
                    radius: 10,
                  ),
                  Positioned(
                    right: 0,
                    child: decContainer(
                      color: const Color(0xffEEEEEE),
                      height: 30,
                      width: 22,
                      radius: 10,
                      align: Alignment.center,
                      child: const Text(
                        'v',
                        style: TextStyle(color: Color(0xff787878)),
                      ),
                    ),
                  )
                ] else ...[
                  IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18, top: 5),
                      child: Text(fromtime),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IgnorePointer(
                      child: decContainer(
                        color: const Color(0xffEEEEEE),
                        height: 30,
                        width: 22,
                        radius: 10,
                        align: Alignment.center,
                        child: const Text(
                          'v',
                          style: TextStyle(color: Color(0xff787878)),
                        ),
                      ),
                    ),
                  )
                ],
              ],
            ),
            const SizedBox(
              width: 23,
            ),
            Stack(
              children: [
                decContainer(
                  height: 30,
                  width: 98,
                  child: AbsorbPointer(
                    child: TimePickerSpinnerPopUp(
                      enable: widget.isFilled,
                      iconSize: 0,
                      mode: CupertinoDatePickerMode.time,
                      //   initTime: toTime ?? DateTime.now(),
                      //  initTime: totime,
                      barrierColor: Colors.black12,

                      //minuteInterval: 2,
                      padding: const EdgeInsets.all(12),
                      cancelText: 'Cancel',
                      confirmText: 'OK',
                      pressType: PressType.singlePress,
                      timeFormat: 'mm',
                      // onChange: _setToTime,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final x = await showDialog(
                      context: context,
                      builder: (context) =>
                          TimeSelector(times: generateHourly59Times()),
                    );
                    if (x != null) {
                      _setToTime(x);
                    }
                  },
                  child: decContainer(
                    color: Colors.white,
                    borderColor: Colors.white,
                    borderWidth: 4,
                    height: 30,
                    width: 98,
                    radius: 10,
                  ),
                ),
                if (!widget.isFilled) ...[
                  IgnorePointer(
                    child: decContainer(
                      color: const Color(0xffBABABA),
                      height: 30,
                      width: 98,
                      radius: 10,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: decContainer(
                      color: const Color(0xffEEEEEE),
                      height: 30,
                      width: 22,
                      radius: 10,
                      align: Alignment.center,
                      child: const Text(
                        'v',
                        style: TextStyle(color: Color(0xff787878)),
                      ),
                    ),
                  )
                ] else ...[
                  IgnorePointer(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18, top: 5),
                      child: Text(totime),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IgnorePointer(
                      child: decContainer(
                        color: const Color(0xffEEEEEE),
                        height: 30,
                        width: 22,
                        radius: 10,
                        align: Alignment.center,
                        child: const Text(
                          'v',
                          style: TextStyle(color: Color(0xff787878)),
                        ),
                      ),
                    ),
                  )
                ],
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }
}

class SemanaEHoras extends ConsumerStatefulWidget {
  const SemanaEHoras({super.key});

  @override
  ConsumerState<SemanaEHoras> createState() => _SemanaEHorasState();
}

class _SemanaEHorasState extends ConsumerState<SemanaEHoras> {
  final Map<String, Hours> hoursMap = {};

  void _onSetHours(String day, String? from, String? to) {
    log('_onSetHours');
    log(day);

    setState(() {
      hoursMap[day] = Hours(from: from ?? '00:00', to: to ?? '23:59');
      // for (final day in hoursMap.entries) {
      //   log('$day: ${day.value}');
      // }
    });
    print('hoursMap: $hoursMap');
  }

  Days _createDaysObject() {
    final days1 = Days(
      monday: hoursMap['monday'],
      tuesday: hoursMap['tuesday'],
      wednesday: hoursMap['wednesday'],
      thursday: hoursMap['thursday'],
      friday: hoursMap['friday'],
      saturday: hoursMap['saturday'],
      sunday: hoursMap['sunday'],
    );

    final day2 = Days(
      monday: hoursMap['Seg'],
      tuesday: hoursMap['Ter'],
      wednesday: hoursMap['Qua'],
      thursday: hoursMap['Qui'],
      friday: hoursMap['Sex'],
      saturday: hoursMap['Sáb'],
      sunday: hoursMap['Dom'],
    );
    // Agora você tem o objeto Days configurado
    log('');
    return days1;
  }

  final List<String> selectedDays = [];

  void handleDayTap(String day) {
    String dayy;
    if (day == 'Dom') {
      dayy = 'sunday';
    } else if (day == 'Seg') {
      dayy = 'monday';
    } else if (day == 'Ter') {
      dayy = 'tuesday';
    } else if (day == 'Qua') {
      dayy = 'wednesday';
    } else if (day == 'Qui') {
      dayy = 'thursday';
    } else if (day == 'Sex') {
      dayy = 'friday';
    } else {
      dayy = 'saturday';
    }
    setState(() {
      if (selectedDays.contains(day)) {
        // Se o dia já está selecionado, remove o dia e os horários associados
        selectedDays.remove(day);
        selectedDays.remove(dayy);
        hoursMap.remove(day);
        hoursMap.remove(dayy);
      } else {
        // Se o dia não está selecionado, adiciona o dia com os horários padrão
        selectedDays.add(day);

        _onSetHours(dayy, "00:00", "23:59"); // Define os horários padrão
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final spaceRegister = ref.watch(newSpaceRegisterVmProvider.notifier);
    final List<String> daysOfWeek = [
      'Seg',
      'Ter',
      'Qua',
      'Qui',
      'Sex',
      'Sáb',
      'Dom'
    ];

    return Scaffold(
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
                  offset: const Offset(0, 2),
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
          'Cadastro de espaço',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 20),
          child: Column(
            children: [
              const Text(
                'Chegou o momento de cadastrar o calendário de aluguel:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xff4300B1),
                ),
              ),
              const SizedBox(
                height: 19,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 27),
                child: Text(
                  'Você deve escolher os dias da semana e os horários que disponibilizará o espaço para alguel.Essas opções poderão ser alteradas posteriormente.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dia da semana',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Início',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(),
                  Text(
                    'Fim',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ...daysOfWeek.asMap().entries.map((entry) {
                        final day = entry.value;
                        final index = entry.key;
                        return Column(
                          children: [
                            RegisterWeekWidget(
                              customKey: Keys.kSelectDayIndex(index),
                              isSelected: selectedDays.contains(day),
                              text: day,
                              onTapCallback: handleDayTap,
                            ),
                            if (index != daysOfWeek.length - 1)
                              const SizedBox(height: 16),
                          ],
                        );
                      }),
                    ],
                  ),
                  const SizedBox(
                    width: 23,
                  ),
                  Column(
                    children: [
                      TimePickerForDay(
                        isFirst: true,
                        dayOfWeek: 'monday',
                        onSetHours: _onSetHours,
                        isFilled: selectedDays.contains('Seg'),
                      ),
                      TimePickerForDay(
                        dayOfWeek: 'tuesday',
                        onSetHours: _onSetHours,
                        isFilled: selectedDays.contains('Ter'),
                      ),
                      TimePickerForDay(
                        dayOfWeek: 'wednesday',
                        onSetHours: _onSetHours,
                        isFilled: selectedDays.contains('Qua'),
                      ),
                      TimePickerForDay(
                        dayOfWeek: 'thursday',
                        onSetHours: _onSetHours,
                        isFilled: selectedDays.contains('Qui'),
                      ),
                      TimePickerForDay(
                        dayOfWeek: 'friday',
                        onSetHours: _onSetHours,
                        isFilled: selectedDays.contains('Sex'),
                      ),
                      TimePickerForDay(
                        dayOfWeek: 'saturday',
                        onSetHours: _onSetHours,
                        isFilled: selectedDays.contains('Sáb'),
                      ),
                      TimePickerForDay(
                        dayOfWeek: 'sunday',
                        onSetHours: _onSetHours,
                        isFilled: selectedDays.contains('Dom'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 31,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 9),
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
                        'Voltar',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  GestureDetector(
                    key: Keys.k9ScreenButton,
                    onTap: () {
                      final days = _createDaysObject();

                      final result = spaceRegister.validateDiaEHoras(
                        days: days,
                      );

                      if (result) {
                        // Messages.showSuccess(
                        //     'semanas e horario escllfo', context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Revisao(),
                          ),
                        );
                      } else {
                        Messages.showError(
                            'Erro ao cadastrar calendário', context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 9),
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
                        'Avançar',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterWeekWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final void Function(String) onTapCallback;
  final Key customKey;

  const RegisterWeekWidget({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTapCallback,
    required this.customKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: customKey,
      onTap: () => onTapCallback(text),
      child: Container(
        alignment: Alignment.center,
        height: 30,
        width: 85,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffE3D9E8) : const Color(0xffBABABA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? const Color(0xff670090) : Colors.white),
        ),
      ),
    );
  }
}

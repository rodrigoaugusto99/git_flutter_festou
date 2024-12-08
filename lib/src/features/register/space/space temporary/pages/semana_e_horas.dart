import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/revisao.dart';
import 'package:git_flutter_festou/src/helpers/helpers.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class TimePickerForDay extends StatefulWidget {
  final String dayOfWeek;
  final Function(String day, String from, String to) onSetHours;
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
  DateTime? fromTime;
  DateTime? toTime;

  void _setFromTime(DateTime dateTime) {
    setState(() {
      fromTime = dateTime;
    });
    if (fromTime != null && toTime != null) {
      widget.onSetHours(
        widget.dayOfWeek,
        _formatTime(fromTime!),
        _formatTime(toTime!),
      );
    }
  }

  void _setToTime(DateTime dateTime) {
    setState(() {
      toTime = dateTime;
    });
    if (fromTime != null && toTime != null) {
      widget.onSetHours(
        widget.dayOfWeek,
        _formatTime(fromTime!),
        _formatTime(toTime!),
      );
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    DateTime fromtime = fromTime ??
        DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);

    DateTime totime = toTime ??
        DateTime.now()
            .copyWith(hour: 23, minute: 59, second: 0, millisecond: 0);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 30,
                  width: 98,
                  child: TimePickerSpinnerPopUp(
                    iconSize: 0,

                    paddingHorizontalOverlay: 50,
                    enable: widget.isFilled,
                    mode: CupertinoDatePickerMode.time,
                    //initTime: fromTime ?? DateTime.now(),
                    initTime: fromtime,
                    barrierColor: Colors.black12,
                    minuteInterval: 1,
                    padding: const EdgeInsets.all(12),
                    cancelText: 'Cancel',
                    confirmText: 'OK',
                    pressType: PressType.singlePress,
                    timeFormat: 'HH:mm',
                    onChange: _setFromTime,
                    radius: 30,
                  ),
                ),
                decContainer(
                  //color: Colors.red,
                  color: Colors.white,
                  borderColor: Colors.white,
                  borderWidth: 4,
                  height: 30,
                  width: 98,
                  radius: 10,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 5),
                    child: Text(_formatTime(fromtime)),
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
                  child: TimePickerSpinnerPopUp(
                    enable: widget.isFilled, iconSize: 0,
                    mode: CupertinoDatePickerMode.time,
                    //   initTime: toTime ?? DateTime.now(),
                    initTime: totime,
                    barrierColor: Colors.black12,
                    minuteInterval: 1,
                    padding: const EdgeInsets.all(12),
                    cancelText: 'Cancel',
                    confirmText: 'OK',
                    pressType: PressType.singlePress,
                    timeFormat: 'HH:mm',
                    onChange: _setToTime,
                  ),
                ),
                decContainer(
                  //color: Colors.red,
                  color: Colors.white,
                  borderColor: Colors.white,
                  borderWidth: 4,
                  height: 30,
                  width: 98,
                  radius: 10,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 5),
                    child: Text(_formatTime(totime)),
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

  void _onSetHours(String day, String from, String to) {
    setState(() {
      hoursMap[day] = Hours(from: from, to: to);
    });
  }

  void _createDaysObject() {
    if (hoursMap.length == 7) {
      final days = Days(
        monday: hoursMap['monday']!,
        tuesday: hoursMap['tuesday']!,
        wednesday: hoursMap['wednesday']!,
        thursday: hoursMap['thursday']!,
        friday: hoursMap['friday']!,
        saturday: hoursMap['saturday']!,
        sunday: hoursMap['sunday']!,
      );
      // Agora você tem o objeto Days configurado
      print(days);
    } else {
      // Nem todos os dias foram configurados
      print('Please set hours for all days!');
    }
  }

  final List<String> selectedDays = [];

  void handleDayTap(String day) {
    setState(() {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
      } else {
        selectedDays.add(day);
      }
    });
    log(selectedDays.toString());
  }

  String? _startTime;
  String? _endTime;

  final List<String> hours = [
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '00',
    '01',
    '02',
    '03',
    '04'
  ];

  List<String> getEndTimeOptions() {
    if (_startTime == null) {
      return [];
    }
    int startIndex = hours.indexOf(_startTime!) + 4;
    return hours.sublist(startIndex);
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
                'Chegou a momento de cadastrar o calendário de aluguel:',
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
                      // const SizedBox(height: 20),
                      // ElevatedButton(
                      //   onPressed: _createDaysObject,
                      //   child: const Text('Create Days Object'),
                      // ),
                    ],
                  ),

                  // Column(
                  //   children: [
                  //     const Text('Os horarios (inicio e fim)'),
                  //     DropdownButton<String>(
                  //       hint: const Text('Select Start Time'),
                  //       value: _startTime,
                  //       items: hours
                  //           .sublist(0, hours.length)
                  //           .map((String value) {
                  //         return DropdownMenuItem<String>(
                  //           value: value,
                  //           child: Text(value),
                  //         );
                  //       }).toList(),
                  //       onChanged: (String? newValue) {
                  //         setState(() {
                  //           _startTime = newValue;
                  //           _endTime =
                  //               null; // Reset end time when start time changes
                  //         });
                  //       },
                  //     ),
                  //     const SizedBox(height: 20),
                  //     DropdownButton<String>(
                  //       hint: const Text('Select End Time'),
                  //       value: _endTime,
                  //       items: getEndTimeOptions().map((String value) {
                  //         return DropdownMenuItem<String>(
                  //           value: value,
                  //           child: Text(value),
                  //         );
                  //       }).toList(),
                  //       onChanged: _startTime == null
                  //           ? null
                  //           : (String? newValue) {
                  //               setState(() {
                  //                 _endTime = newValue;
                  //                 log(_startTime.toString());
                  //                 log(_endTime.toString());
                  //               });
                  //             },
                  //     ),
                  //   ],
                  // )
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
                    onTap: () {
                      if (_startTime != null && _endTime != null) {
                        final result = spaceRegister.validateDiaEHoras(
                            startTime: _startTime!,
                            endTime: _endTime!,
                            days: selectedDays);
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
                      } else {
                        Messages.showError('Complete os horarios', context);
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

  const RegisterWeekWidget({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/revisao.dart';

class SemanaEHoras extends ConsumerStatefulWidget {
  const SemanaEHoras({super.key});

  @override
  ConsumerState<SemanaEHoras> createState() => _SemanaEHorasState();
}

class _SemanaEHorasState extends ConsumerState<SemanaEHoras> {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 20),
        child: Column(
          children: [
            Column(
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
                Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Dia da semana'),
                          ...daysOfWeek.map((day) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RegisterWeekWidget(
                                isSelected: selectedDays.contains(day),
                                text: day,
                                onTapCallback: handleDayTap,
                              ),
                            );
                          }),
                        ]),
                    Column(
                      children: [
                        const Text('Os horarios (inicio e fim)'),
                        DropdownButton<String>(
                          hint: const Text('Select Start Time'),
                          value: _startTime,
                          items: hours
                              .sublist(0, hours.length)
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _startTime = newValue;
                              _endTime =
                                  null; // Reset end time when start time changes
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButton<String>(
                          hint: const Text('Select End Time'),
                          value: _endTime,
                          items: getEndTimeOptions().map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: _startTime == null
                              ? null
                              : (String? newValue) {
                                  setState(() {
                                    _endTime = newValue;
                                    log(_startTime.toString());
                                    log(_endTime.toString());
                                  });
                                },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 69, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
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
                    Messages.showError('Erro ao cadastrar calendário', context);
                  }
                } else {
                  Messages.showError('Complete os horarios', context);
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
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

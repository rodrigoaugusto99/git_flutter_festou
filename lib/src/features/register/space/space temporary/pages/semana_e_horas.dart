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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              child: Text(
                'os dias da semana que vc aluga',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: daysOfWeek.map((day) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RegisterWeekWidget(
                        isSelected: selectedDays.contains(day),
                        text: day,
                        onTapCallback: handleDayTap,
                      ),
                    );
                  }).toList(),
                ),
                Column(
                  children: [
                    const Text('Os horarios (inicio e fim)'),
                    DropdownButton<String>(
                      hint: const Text('Select Start Time'),
                      value: _startTime,
                      items: hours.sublist(0, hours.length).map((String value) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Voltar',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (_startTime != null && _endTime != null) {
                      final result = spaceRegister.validateDiaEHoras(
                          startTime: _startTime!,
                          endTime: _endTime!,
                          days: selectedDays);
                      if (result) {
                        Messages.showSuccess(
                            'semanas e horario escllfo', context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Revisao(),
                          ),
                        );
                      } else {
                        Messages.showError('deu ruim', context);
                      }
                    } else {
                      Messages.showError('Complete os horarios', context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: const Text(
                      'Avançar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
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
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTapCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapCallback(text),
      child: Container(
        alignment: Alignment.center,
        height: 30,
        width: 70,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue
              : const Color.fromARGB(255, 202, 200, 200),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

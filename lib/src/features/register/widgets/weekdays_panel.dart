// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WeekDaysPanel extends StatelessWidget {
  final ValueChanged<String> onDayPressed;
  final String text;
  const WeekDaysPanel({
    required this.onDayPressed,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          //rolagem caso dispositivo pequeno
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonDay(
                  label: 'Seg',
                  onDayPressed: onDayPressed,
                ),
                ButtonDay(
                  label: 'Ter',
                  onDayPressed: onDayPressed,
                ),
                ButtonDay(
                  label: 'Qua',
                  onDayPressed: onDayPressed,
                ),
                ButtonDay(
                  label: 'Qui',
                  onDayPressed: onDayPressed,
                ),
                ButtonDay(
                  label: 'Sex',
                  onDayPressed: onDayPressed,
                ),
                ButtonDay(
                  label: 'Sab',
                  onDayPressed: onDayPressed,
                ),
                ButtonDay(
                  label: 'Dom',
                  onDayPressed: onDayPressed,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ButtonDay extends StatefulWidget {
  final String label;
  final ValueChanged<String> onDayPressed;

  const ButtonDay({
    super.key,
    required this.label,
    required this.onDayPressed,
  });

  @override
  State<ButtonDay> createState() => _ButtonDayState();
}

class _ButtonDayState extends State<ButtonDay> {
  //1 - variavel de estado
  var selected = false;
  @override
  Widget build(BuildContext context) {
    final ButtonDay(:onDayPressed, :label) = widget;
    //1 - variaveis esteticas que mudam com o clique
    final textColor = selected ? Colors.white : Colors.brown;
    var buttonColor = selected ? Colors.brown : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        //se for pra desabilitar, botao inclicavel.(onTap null)
        onTap: () {
          //no onTap do botao que inverte o estado dele
          setState(() {
            onDayPressed(label);
            selected = !selected;
          });
        },
        child: Container(
          width: 40,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            //1- variavel estetica
            color: buttonColor,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                //1- variavel estetica
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

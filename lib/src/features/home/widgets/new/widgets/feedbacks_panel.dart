import 'package:flutter/material.dart';

class FeedbacksPanel extends StatelessWidget {
  final ValueChanged<String> onNotePressed;
  final String text;
  const FeedbacksPanel({
    super.key,
    required this.onNotePressed,
    required this.text,
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
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          //rolagem caso dispositivo pequeno
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonDay(
                  label: '0+',
                  onNotePressed: onNotePressed,
                  color: Colors.red,
                ),
                ButtonDay(
                  label: '7+',
                  onNotePressed: onNotePressed,
                  color: Colors.orange,
                ),
                ButtonDay(
                  label: '7.5+',
                  onNotePressed: onNotePressed,
                  color: const Color.fromARGB(255, 108, 209, 112),
                ),
                ButtonDay(
                  label: '8+',
                  onNotePressed: onNotePressed,
                  color: Colors.green,
                ),
                ButtonDay(
                  label: '8.5+',
                  onNotePressed: onNotePressed,
                  color: const Color.fromARGB(255, 9, 134, 13),
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
  final Color color;
  final ValueChanged<String> onNotePressed;

  const ButtonDay({
    super.key,
    required this.label,
    required this.onNotePressed,
    required this.color,
  });

  @override
  State<ButtonDay> createState() => _ButtonDayState();
}

class _ButtonDayState extends State<ButtonDay> {
  //1 - variavel de estado
  var selected = false;
  @override
  Widget build(BuildContext context) {
    final ButtonDay(:onNotePressed, :label, :color) = widget;
    //1 - variaveis esteticas que mudam com o clique

    var buttonColor = selected ? Colors.grey : color;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        //se for pra desabilitar, botao inclicavel.(onTap null)
        onTap: () {
          //no onTap do botao que inverte o estado dele
          setState(() {
            onNotePressed(label);
            selected = !selected;
          });
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(8),
            //1- variavel estetica
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                //1- variavel estetica
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

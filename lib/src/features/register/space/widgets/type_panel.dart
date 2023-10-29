// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';

class TypePanel extends StatelessWidget {
  final ValueChanged<String> onTypePressed;
  final String text;
  const TypePanel({
    required this.onTypePressed,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text(text),
          const SizedBox(
            height: 16,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: List.generate(
              ListConstants.availableTypes.length,
              (index) => ButtonType(
                onTypePressed: onTypePressed,
                label: ListConstants.availableTypes[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonType extends StatefulWidget {
  final ValueChanged<String> onTypePressed;
  final String label;

  const ButtonType({
    super.key,
    required this.label,
    required this.onTypePressed,
  });

  @override
  State<ButtonType> createState() => _ButtonTypeState();
}

class _ButtonTypeState extends State<ButtonType> {
  //1 - variavel de estado
  var selected = false;
  @override
  Widget build(BuildContext context) {
    final ButtonType(:onTypePressed, :label) = widget;
    //1 - variaveis esteticas que mudam com o clique
    final textColor = selected ? Colors.white : Colors.brown;
    var buttonColor = selected ? Colors.brown : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() {
            onTypePressed(label);
            selected = !selected;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            //1- variavel estetica
            color: buttonColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

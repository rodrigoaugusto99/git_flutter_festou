// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ServicesPanel extends StatelessWidget {
  final ValueChanged<String> onServicePressed;
  final String text;
  ServicesPanel({
    super.key,
    required this.onServicePressed,
    required this.text,
  });

  final List<String> availableServices = [
    'Cozinha',
    'Garçons',
    'Decoração',
    'Som e Iluminação',
    'Estacionamento',
    'Banheiros',
    'Segurança',
    'Ar-condicionado',
    'Limpeza ',
    'Bar',
  ];

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
              availableServices.length,
              (index) => ButtonType(
                onServicePressed: onServicePressed,
                label: availableServices[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonType extends StatefulWidget {
  final String label;
  final ValueChanged<String> onServicePressed;

  const ButtonType({
    super.key,
    required this.label,
    required this.onServicePressed,
  });

  @override
  State<ButtonType> createState() => _ButtonTypeState();
}

class _ButtonTypeState extends State<ButtonType> {
  //1 - variavel de estado
  var selected = false;
  @override
  Widget build(BuildContext context) {
    final ButtonType(:onServicePressed, :label) = widget;
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
            onServicePressed(label);
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

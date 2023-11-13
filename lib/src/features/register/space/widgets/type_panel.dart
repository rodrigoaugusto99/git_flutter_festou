// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';

class TypePanel extends StatelessWidget {
  final ValueChanged<String> onTypePressed;
  final String text;
  final List<String> selectedTypes;
  const TypePanel({
    required this.onTypePressed,
    required this.text,
    required this.selectedTypes,
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
              (index) {
                final type = ListConstants.availableTypes[index];
                final isSelected = selectedTypes
                    .contains(type); // Verifique se o serviço está selecionado

                return ButtonType(
                  onTypePressed: onTypePressed,
                  label: type,
                  isSelected:
                      isSelected, // Passe o valor isSelected para o botão
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ButtonType extends StatefulWidget {
  final ValueChanged<String> onTypePressed;
  final String label;
  bool isSelected;
  ButtonType({
    super.key,
    required this.label,
    required this.onTypePressed,
    required this.isSelected,
  });

  @override
  State<ButtonType> createState() => _ButtonTypeState();
}

class _ButtonTypeState extends State<ButtonType> {
  @override
  Widget build(BuildContext context) {
    final ButtonType(:onTypePressed, :label) = widget;
    //1 - variaveis esteticas que mudam com o clique
    final textColor = widget.isSelected ? Colors.white : Colors.brown;
    var buttonColor = widget.isSelected ? Colors.brown : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() {
            onTypePressed(label);
            widget.isSelected = !widget.isSelected;
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

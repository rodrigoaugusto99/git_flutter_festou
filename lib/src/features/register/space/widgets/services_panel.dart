// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:festou/src/core/ui/constants.dart';
import 'package:festou/src/helpers/keys.dart';

class ServicesPanel extends StatelessWidget {
  final ValueChanged<String> onServicePressed;
  final String text;
  final List<String> selectedServices; // Adicione as seleções atuais aqui

  const ServicesPanel({
    required this.onServicePressed,
    required this.text,
    required this.selectedServices, // Passe as seleções atuais como argumento
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: List.generate(
              ListConstants.availableServices.length,
              (index) {
                final service = ListConstants.availableServices[index];
                final isSelected = selectedServices.contains(
                    service); // Verifique se o serviço está selecionado

                return ButtonType(
                  onServicePressed: onServicePressed,
                  label: service,
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
  final String label;
  final ValueChanged<String> onServicePressed;
  bool isSelected; // Adicione a propriedade isSelected

  ButtonType({
    super.key,
    required this.label,
    required this.onServicePressed,
    required this.isSelected, // Passe isSelected como argumento
  });

  @override
  State<ButtonType> createState() => _ButtonTypeState();
}

class _ButtonTypeState extends State<ButtonType> {
  //1 - variavel de estado

  @override
  Widget build(BuildContext context) {
    final ButtonType(:onServicePressed, :label) = widget;
    //1 - variaveis esteticas que mudam com o clique
    final textColor =
        widget.isSelected ? const Color(0xff670090) : Colors.white;
    var buttonColor =
        widget.isSelected ? const Color(0xffE3D9E8) : const Color(0xffBABABA);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        key: Keys.kChipWidget,
        borderRadius: BorderRadius.circular(8),
        //se for pra desabilitar, botao inclicavel.(onTap null)
        onTap: () {
          //no onTap do botao que inverte o estado dele
          setState(() {
            onServicePressed(label);
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

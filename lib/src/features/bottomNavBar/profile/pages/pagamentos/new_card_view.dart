import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/widgets/custom_textformfield.dart';
import 'package:git_flutter_festou/src/models/card_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validatorless/validatorless.dart';

class NewCardView extends StatefulWidget {
  bool? isNew;
  NewCardView({
    super.key,
    this.isNew = false,
  });

  @override
  State<NewCardView> createState() => _NewCardViewState();
}

class _NewCardViewState extends State<NewCardView> {
  // final nameEC = TextEditingController(text: 'Emília Faria M Souza');
  // final cardNumberEC = TextEditingController(text: '7894 1234 4568 2580');
  // final validateDateEC = TextEditingController(text: '01/29');
  // final cvvEC = TextEditingController(text: '100');
  // final flagEC = TextEditingController(text: 'Cartão Master 2');
  TextEditingController nameEC = TextEditingController();
  TextEditingController cardNumberEC = TextEditingController();
  TextEditingController validateDateEC = TextEditingController();
  TextEditingController cvvEC = TextEditingController();
  TextEditingController flagEC = TextEditingController();
  bool _isChecked = false;

  var dateMaskFormatter = MaskTextInputFormatter(
    mask: '##/##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  var cvvFormatter = MaskTextInputFormatter(
    mask: '###',
    filter: {"#": RegExp('[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  var cardNumberFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp('[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  // List of card flags
  final List<String> cardFlags = [
    'Visa',
    'MasterCard',
    'American Express',
    'Discover'
  ];

  void showPopupMenu({
    required BuildContext context,
    required Offset offset,
  }) async {
    await showMenu(
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 500),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(24)),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + 10,
        offset.dx,
        offset.dy,
      ),

      items: cardFlags.map((flag) {
        return PopupMenuItem(
          child: ListTile(
            title: Text(flag),
            onTap: () {
              Navigator.of(context).pop();
              onFlagSelected(flag);
            },
          ),
        );
      }).toList(),
    );
  }

  void onFlagSelected(String? flag) {
    if (flag != null) {
      setState(() {
        flagEC.text = flag;
      });
    }
  }

  final formKey = GlobalKey<FormState>();

  FormFieldValidator<String> validate() {
    return Validatorless.required('Campo obrigatório');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
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
                  offset: const Offset(0, 2), // changes position of shadow
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Adicionar novo cartão',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: screenWidth / 2,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: const Color(0xff4300B1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 31, right: 22, top: 22, bottom: 11),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Festou',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            cardNumberEC.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'PORTADOR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    nameEC.text,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'VALIDADE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    validateDateEC.text,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: screenWidth / 2.5,
                    width: screenWidth / 2.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: screenWidth / 8.5,
                  child: Container(
                    height: screenWidth / 2.5,
                    width: screenWidth / 2.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),
                Positioned(
                  top: 24,
                  right: screenWidth / 11.5,
                  child: SizedBox(
                    height: screenWidth / 3,
                    width: screenWidth / 3,
                    child: Image.asset(
                      'lib/assets/images/festou-logo.png',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 45),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextformfield(
                      onChanged: (p0) => setState(() {}),
                      ddd: 10,
                      svgPath: 'lib/assets/images/image 6perssoa.png',
                      hintText: 'Nome',
                      controller: nameEC,
                      validator: validate(),
                    ),
                    const SizedBox(height: 15),
                    CustomTextformfield(
                      onChanged: (p0) => setState(() {}),
                      ddd: 5,
                      hintText: 'Cartão',
                      keyboardType: TextInputType.number,
                      controller: cardNumberEC,
                      inputFormatters: [cardNumberFormatter],
                      svgPath: 'lib/assets/images/image 4card.png',
                      validator: validate(),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextformfield(
                            onChanged: (p0) => setState(() {}),
                            ddd: 10,
                            svgPath: 'lib/assets/images/image 5cardcvv.png',
                            controller: cvvEC,
                            inputFormatters: [cvvFormatter],
                            validator: validate(),
                            keyboardType: TextInputType.number,
                            hintText: 'CVV',
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CustomTextformfield(
                            onChanged: (p0) => setState(() {}),
                            ddd: 2, validator: validate(),
                            svgPath: 'lib/assets/images/image 4calendarrrr.png',
                            //label: 'aa',
                            keyboardType: TextInputType.number,
                            controller: validateDateEC,
                            inputFormatters: [dateMaskFormatter],
                            hintText: 'Validade',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      // onTap: () {
                      //   if (selectedFlag != null) {
                      //     final message = 'Selected Card Flag: $selectedFlag';
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text(message)),
                      //     );
                      //   } else {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //           content: Text('Please select a card flag first')),
                      //     );
                      //   }
                      // },
                      child: GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          showPopupMenu(
                            context: context,
                            offset: details.globalPosition,
                          );
                        },
                        child: CustomTextformfield(
                          validator: validate(),
                          enable: false,
                          //  onChanged: (p0) => setState(() {}),
                          ddd: 10,
                          svgPath: 'lib/assets/images/image 7passa.png',
                          controller: flagEC,
                          hintText: 'Bandeira',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(bottom: 20, left: 30, right: 30, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    side: const BorderSide(),
                    activeColor: Colors.transparent,
                    splashRadius: 0,
                    checkColor: Colors.black,
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                  ),
                  const Text(
                    'Definir como método de pagamento principal',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (formKey.currentState?.validate() == false) {
                  //  Messages.showError('Formulár', context);
                  return;
                }
                CardModel card = CardModel(
                  bandeira: flagEC.text,
                  cvv: cvvEC.text,
                  name: nameEC.text,
                  number: cardNumberEC.text,
                  validate: validateDateEC.text,
                );
                try {
                  final cardId = await card.saveToFirestore();

                  card.id = cardId;

                  Navigator.pop(context, card);
                } on Exception catch (e) {
                  log(e.toString());
                  Messages.showError('Erro ao cadastrar cartão', context);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff9747FF),
                        Color(0xff4300B1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(50)),
                child: const Text(
                  'Adicionar cartão',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myRow(
      {required String text,
      required Widget icon,
      required Function()? onTap,
      Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color ?? Colors.white,
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 10,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}

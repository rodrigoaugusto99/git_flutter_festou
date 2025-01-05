import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/widgets/custom_textformfield.dart';
import 'package:git_flutter_festou/src/models/card_model.dart';
import 'package:git_flutter_festou/src/models/user_model.dart';
import 'package:git_flutter_festou/src/services/user_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validatorless/validatorless.dart';

class NewCardView extends StatefulWidget {
  String? id;
  final String? name;
  final String? cardName;
  final String? number;
  final String? validateDate;
  final String? cvv;

  NewCardView({
    super.key,
    this.id,
    this.name,
    this.cardName,
    this.number,
    this.validateDate,
    this.cvv,
  });

  @override
  State<NewCardView> createState() => _NewCardViewState();
}

class _NewCardViewState extends State<NewCardView> {
  UserModel? userModel;
  TextEditingController nameEC = TextEditingController();
  TextEditingController cardNameEC = TextEditingController();
  TextEditingController numberEC = TextEditingController();
  TextEditingController validateDateEC = TextEditingController();
  TextEditingController cvvEC = TextEditingController();
  TextEditingController flagEC = TextEditingController();
  bool _isChecked = false;
  bool _isNewCard = true;

  void fetchUser() async {
    userModel = await UserService().getCurrentUserModel();
    setState(() {});
  }

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

  @override
  void initState() {
    super.initState();
    fetchUser();

    // Inicializando os controladores com os valores passados
    nameEC = TextEditingController(text: widget.name ?? '');
    cardNameEC = TextEditingController(text: widget.cardName ?? '');
    numberEC = TextEditingController(
      text: widget.number != null
          ? cardNumberFormatter.maskText(widget.number!)
          : '',
    );
    validateDateEC = TextEditingController(
      text: widget.validateDate != null
          ? dateMaskFormatter.maskText(widget.validateDate!)
          : '',
    );
    cvvEC = TextEditingController(
      text: widget.cvv != null ? cvvFormatter.maskText(widget.cvv!) : '',
    );

    if (nameEC.text.isNotEmpty || cardNameEC.text.isNotEmpty) {
      _isNewCard = false;
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
                                'Festou!',
                                style: TextStyle(
                                  fontFamily: 'Valentine',
                                  color: Color.fromARGB(255, 154, 110, 255),
                                  fontSize: 44,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            numberEC.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
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
                                      fontSize: 10,
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
                                      fontSize: 10,
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
            const SizedBox(height: 10),
            const Text(
              'Preencha com os dados exatos do seu cartão.',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
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
                      hintText: 'Nome do portador',
                      controller: nameEC,
                      validator: validate(),
                    ),
                    const SizedBox(height: 15),
                    CustomTextformfield(
                      onChanged: (p0) => setState(() {}),
                      ddd: 5,
                      hintText: 'Número do cartão',
                      keyboardType: TextInputType.number,
                      controller: numberEC,
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
                    CustomTextformfield(
                      onChanged: (p0) => setState(() {}),
                      ddd: 10,
                      validator: validate(),
                      svgPath: 'lib/assets/images/image 7passa.png',
                      controller: cardNameEC,
                      hintText: 'Dê um nome ao seu cartão',
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
            SizedBox(height: _isNewCard ? 50 : 30),
            GestureDetector(
              onTap: () async {
                if (formKey.currentState?.validate() == false) {
                  return;
                }
                CardModel card = CardModel(
                  name: nameEC.text,
                  number: numberEC.text,
                  cvv: cvvEC.text,
                  validateDate: validateDateEC.text,
                  cardName: cardNameEC.text,
                );
                try {
                  final cardId =
                      await card.saveToFirestore(userModel?.docId ?? '');

                  card.id = cardId;

                  Navigator.of(context)
                      .pop(card); // Retorna o cartão recém-adicionado
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
                child: Text(
                  _isNewCard ? 'Adicionar cartão' : 'Salvar alterações',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 5),
            _isNewCard
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () async {
                      try {
                        final BuildContext context2 =
                            Navigator.of(context).context;
                        await showDialog(
                          context: context2,
                          builder: (BuildContext context2) {
                            return AlertDialog(
                              title: const Text('Excluir cartão'),
                              content: const Text(
                                  'Tem certeza de que deseja excluir o cartão?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context2).pop(),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context2)
                                        .pop(); // Fecha o diálogo

                                    if (widget.id != null) {
                                      final cardSnapshot =
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(userModel?.docId)
                                              .collection('cards')
                                              .doc(widget.id)
                                              .get();

                                      if (cardSnapshot.exists) {
                                        await cardSnapshot.reference.delete();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Cartão excluído com sucesso!'),
                                          ),
                                        );

                                        // Retorna para a tela anterior com uma indicação de exclusão
                                        Navigator.of(context).pop('deleted');
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Cartão não encontrado!'),
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Erro: número do cartão inválido!'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Excluir'),
                                ),
                              ],
                            );
                          },
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao excluir cartão: $e')),
                        );
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
                        'Excluir cartão',
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
}

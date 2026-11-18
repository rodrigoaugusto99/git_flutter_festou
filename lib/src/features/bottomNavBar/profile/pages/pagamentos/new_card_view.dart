import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/core/ui/helpers/messages.dart';
import 'package:festou/src/features/widgets/custom_textformfield.dart';
import 'package:festou/src/models/card_model.dart';
import 'package:festou/src/models/user_model.dart';
import 'package:festou/src/services/encryption_service.dart';
import 'package:festou/src/services/user_service.dart';
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
  final encryptionService =
      EncryptionService("criptfestouaplic", "2199478465899478");
  UserModel? userModel;
  TextEditingController nameEC = TextEditingController();
  TextEditingController cardNameEC = TextEditingController();
  TextEditingController numberEC = TextEditingController();
  TextEditingController validateDateEC = TextEditingController();
  TextEditingController cvvEC = TextEditingController();
  TextEditingController flagEC = TextEditingController();
  bool _isChecked = false;
  bool _isNewCard = true;
  bool _wasItThisCard = false;

  Future<void> fetchUser() async {
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
    initializeData();

    // Função para verificar se o texto está criptografado
    bool isEncrypted(String? text) {
      if (text == null || text.isEmpty) return false;
      return !(text.length == 16 || text.length == 3 || text.length == 4);
    }

    // Verificar e descriptografar os valores, se necessário
    final decryptedNumber = widget.number != null && isEncrypted(widget.number)
        ? encryptionService.decrypt(widget.number!)
        : widget.number ?? ''; // Já descriptografado ou vazio
    final decryptedValidateDate =
        widget.validateDate != null && isEncrypted(widget.validateDate)
            ? encryptionService.decrypt(widget.validateDate!)
            : widget.validateDate ?? '';
    final decryptedCVV = widget.cvv != null && isEncrypted(widget.cvv)
        ? encryptionService.decrypt(widget.cvv!)
        : widget.cvv ?? '';

    // Inicializando os controladores com os valores descriptografados ou já prontos
    nameEC = TextEditingController(text: widget.name ?? '');
    cardNameEC = TextEditingController(text: widget.cardName ?? '');
    numberEC = TextEditingController(
      text: decryptedNumber.isNotEmpty
          ? cardNumberFormatter.maskText(decryptedNumber)
          : '',
    );
    validateDateEC = TextEditingController(
      text: decryptedValidateDate.isNotEmpty
          ? dateMaskFormatter.maskText(decryptedValidateDate)
          : '',
    );
    cvvEC = TextEditingController(
      text: decryptedCVV.isNotEmpty ? cvvFormatter.maskText(decryptedCVV) : '',
    );

    if (nameEC.text.isNotEmpty || cardNameEC.text.isNotEmpty) {
      _isNewCard = false;
    }
  }

  /// Inicializa os dados do usuário e verifica o método principal de pagamento
  void initializeData() async {
    await fetchUser(); // Aguarda a conclusão do carregamento do usuário
    if (userModel != null) {
      checkIfMainPaymentMethod(); // Só chama a verificação após o usuário estar carregado
    }
  }

  void checkIfMainPaymentMethod() async {
    try {
      final userId = userModel?.docId ?? '';
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        if (userData != null) {
          final isPrincipal = userData['principal_method_payment'] == widget.id;

          setState(() {
            _wasItThisCard = isPrincipal; // Define se era o cartão principal
            _isChecked = isPrincipal; // Marca a checkbox automaticamente
          });
        }
      }
    } catch (e) {
      log('Erro ao verificar o método principal de pagamento: $e');
    }
  }

  DocumentReference getUserRef() {
    final userId = userModel?.docId ?? '';
    return FirebaseFirestore.instance.collection('users').doc(userId);
  }

  Future<void> updatePrincipalPaymentMethod(String? cardId) async {
    final userRef = getUserRef();
    await userRef.update({'principal_method_payment': cardId ?? ''});
  }

  Future<void> saveOrUpdateCard(CardModel card) async {
    // return;
    final cardRef = getUserRef().collection('cards').doc(widget.id);

    if (widget.id != null) {
      final snapshot = await cardRef.get();

      if (snapshot.exists) {
        // Atualiza os dados do cartão existente
        await cardRef.update(card.toMap(isUpdate: true));

        // Atualiza o método principal de pagamento, se necessário
        if (_isChecked && !_wasItThisCard) {
          await updatePrincipalPaymentMethod(widget.id);
        } else if (!_isChecked && _wasItThisCard) {
          await updatePrincipalPaymentMethod(null);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados atualizado com sucesso!')),
        );
      } else {
        // Cria um novo cartão caso o ID exista no widget mas o cartão não esteja no Firestore
        await cardRef.set(card.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cartão criado com sucesso!')),
        );
      }
    } else {
      // Cria um novo cartão caso o ID não exista
      final newCardRef = await getUserRef()
          .collection('cards')
          .add(card.toMap(isUpdate: false));
      card.id = newCardRef.id;

      if (_isChecked) {
        await updatePrincipalPaymentMethod(card.id);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Novo cartão adicionado com sucesso!')),
      );
    }
  }

  final formKey = GlobalKey<FormState>();

  bool isValidDate(String input) {
    if (input.length != 4) {
      return false;
    }

    List<String> parts = [];
    parts.add(input.substring(0, 2));
    parts.add(input.substring(2));
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) {
      return false;
    }

    // Verificar se o mês está entre 1 e 12
    if (month < 1 || month > 12) {
      return false;
    }

    // Verificar se o ano está entre 0 e 99
    if (year < 0 || year > 99) {
      return false;
    }

    return true;
  }

  FormFieldValidator<String> validate() {
    return Validatorless.required('Campo obrigatório');
  }

  static const _bg = Color(0xFFFAF7FC);
  static const _ink = Color(0xFF1C1426);
  static const _muted = Color(0xFF8A8096);
  static const _accent = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.of(context).pop(null),
                      child: Ink(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE8DFF8)),
                          boxShadow: [
                            BoxShadow(
                              color: _accent.withOpacity(0.07),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: _ink,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isNewCard ? 'Adicionar cartão' : 'Editar cartão',
                          style: const TextStyle(
                            fontFamily: 'RedHatDisplay',
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            letterSpacing: -0.4,
                            color: _ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _isNewCard
                              ? 'Cadastre um novo cartão'
                              : 'Atualize os dados do cartão',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: screenWidth / 2,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF9747FF),
                                  Color(0xFF6100FF),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: _accent.withOpacity(0.28),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
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
                      'lib/assets/images/logo_festou.png',
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Text(
                'Preencha com os dados exatos do seu cartão.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _muted,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextformfield(
                      onChanged: (p0) => setState(() {}),
                      ddd: 0,
                      scale: 3.5,
                      svgPath: 'lib/assets/images/icon_pessoa.png',
                      hintText: 'Nome do portador',
                      controller: nameEC,
                      validator: validate(),
                    ),
                    const SizedBox(height: 12),
                    CustomTextformfield(
                      onChanged: (p0) => setState(() {}),
                      ddd: 0,
                      svgWidth: 5,
                      scale: 3.8,
                      horizontalPadding: 0,
                      hintText: 'Número do cartão',
                      keyboardType: TextInputType.number,
                      controller: numberEC,
                      inputFormatters: [cardNumberFormatter],
                      svgPath: 'lib/assets/images/card-number.png',
                      validator: validate(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextformfield(
                            onChanged: (p0) => setState(() {}),
                            ddd: 0,
                            scale: 3.3,
                            svgPath: 'lib/assets/images/icon_card_cvv.png',
                            controller: cvvEC,
                            inputFormatters: [cvvFormatter],
                            validator: validate(),
                            keyboardType: TextInputType.number,
                            hintText: 'CVV',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextformfield(
                            onChanged: (p0) => setState(() {}),
                            ddd: 0,
                            validator: (value) {
                              final unmaskedValue =
                                  value != null && value.isNotEmpty
                                      ? dateMaskFormatter.unmaskText(value)
                                      : dateMaskFormatter.getUnmaskedText();

                              if (!isValidDate(unmaskedValue)) {
                                return 'Data inválida (MM/AA)';
                              }
                              return null;
                            },
                            scale: 3.3,
                            svgPath: 'lib/assets/images/icon_calendar.png',
                            keyboardType: TextInputType.number,
                            controller: validateDateEC,
                            inputFormatters: [dateMaskFormatter],
                            hintText: 'MM/AA',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomTextformfield(
                      onChanged: (p0) => setState(() {}),
                      ddd: 0,
                      scale: 3.3,
                      validator: validate(),
                      svgPath: 'lib/assets/images/icon_card_check.png',
                      controller: cardNameEC,
                      hintText: 'Dê um nome ao seu cartão',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        setState(() => _isChecked = !_isChecked);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              activeColor: _accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value ?? false;
                                });
                              },
                            ),
                            const Expanded(
                              child: Text(
                                'Definir como método de pagamento principal',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _primaryButton(
                    label: _isNewCard
                        ? 'Adicionar cartão'
                        : 'Salvar alterações',
                    onTap: () async {
                      if (formKey.currentState?.validate() == false) {
                        return;
                      }

                      final card = CardModel(
                        id: widget.id,
                        name: nameEC.text,
                        cardName: cardNameEC.text,
                        number: encryptionService.encrypt(
                            numberEC.text.replaceAll(' ', '')),
                        validateDate: encryptionService.encrypt(
                            validateDateEC.text.replaceAll('/', '')),
                        cvv: encryptionService.encrypt(cvvEC.text),
                      );

                      try {
                        saveOrUpdateCard(card);
                        Navigator.of(context).pop(card);
                      } on Exception catch (e) {
                        log(e.toString());
                        Messages.showError('Erro ao salvar o cartão', context);
                      }
                    },
                  ),
                  if (!_isNewCard) ...[
                    const SizedBox(height: 10),
                    _dangerButton(
                      label: 'Excluir cartão',
                      onTap: () async {
                        try {
                          await showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                title: const Text(
                                  'Excluir cartão',
                                  style: TextStyle(
                                    fontFamily: 'RedHatDisplay',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                content: const Text(
                                  'Tem certeza de que deseja excluir o cartão?',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(dialogContext).pop(),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(dialogContext).pop();

                                      if (widget.id != null) {
                                        final cardSnapshot =
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(userModel?.docId)
                                                .collection('cards')
                                                .doc(widget.id)
                                                .get();

                                        if (cardSnapshot.exists) {
                                          await cardSnapshot.reference
                                              .delete();

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Cartão excluído com sucesso!'),
                                            ),
                                          );

                                          Navigator.of(context).pop('deleted');
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Cartão não encontrado!'),
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
                                    child: const Text(
                                      'Excluir',
                                      style: TextStyle(
                                        color: Color(0xFFFF4D6D),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Erro ao excluir cartão: $e')),
                          );
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 10),
                  _secondaryButton(
                    label: 'Voltar',
                    onTap: () => Navigator.of(context).pop(null),
                  ),
                ],
              ),
            ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF9747FF), Color(0xFF6100FF)],
            ),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(0.28),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _secondaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE0D0FF)),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: _accent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dangerButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: const Color(0xFFFFD0D8)),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFFFF4D6D),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

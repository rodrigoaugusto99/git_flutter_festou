import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/semana_e_horas.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/textfield.dart';
import 'package:git_flutter_festou/src/helpers/helpers.dart';

class Preco extends ConsumerStatefulWidget {
  const Preco({super.key});

  @override
  ConsumerState<Preco> createState() => _PrecoState();
}

class _PrecoState extends ConsumerState<Preco> {
  int extrairNumerosComoInteiro(String texto) {
    // Remove todos os caracteres não numéricos da string
    String apenasNumeros = texto.replaceAll(RegExp(r'[^0-9]'), '');

    // Converte a string resultante em um inteiro
    return int.tryParse(apenasNumeros) ?? 0;
  }

  final precoEC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final spaceRegister = ref.watch(newSpaceRegisterVmProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8F8F8),
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 20),
        child: Column(
          children: [
            Column(
              children: [
                const Text(
                  'Agora, determine seu preço por hora:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xff4300B1),
                  ),
                ),
                const SizedBox(
                  height: 19,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 27),
                  child: Text(
                    'Você poderá alterá-lo quando quiser, porém sendo mantido o valor que estava em vigor no momento dos contratos que já foram firmados.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                myRow(
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      locale: 'pt-BR',
                      symbol: 'R\$',
                    )
                  ],
                  onlyNumber: true,
                  // prefix: 'R\$ ',
                  validator: spaceRegister.validateBairro(),
                  label: 'Preço do espaço',
                  controller: precoEC,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 69, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                alignment: Alignment.center,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff9747FF),
                      Color(0xff44300b1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Text(
                  'Voltar',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 9,
            ),
            GestureDetector(
              onTap: () {
                final formattedPrice =
                    transformarParaFormatoDecimal2(precoEC.text);
                final result = spaceRegister.validatePreco(
                  formattedPrice,
                );
                if (result) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SemanaEHoras(),
                    ),
                  );
                } else {
                  Messages.showInfo('Escolha um preço', context);
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                alignment: Alignment.center,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff9747FF),
                      Color(0xff44300b1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Text(
                  'Avançar',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/servicos_acomodacoes.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/textfield.dart';
import 'package:git_flutter_festou/src/helpers/keys.dart';
import 'package:search_cep/search_cep.dart';

class Localizacao extends ConsumerStatefulWidget {
  const Localizacao({super.key});

  @override
  ConsumerState<Localizacao> createState() => _LocalizacaoState();
}

class _LocalizacaoState extends ConsumerState<Localizacao> {
  final formKey = GlobalKey<FormState>();

  final cepEC = TextEditingController();
  final logradouroEC = TextEditingController();
  final numeroEC = TextEditingController();
  final bairroEC = TextEditingController();
  final cidadeEC = TextEditingController();
  final cityEC = TextEditingController();

  bool isCepAutoCompleted = false;

  @override
  void dispose() {
    super.dispose();

    cepEC.dispose();
    logradouroEC.dispose();
    bairroEC.dispose();
    numeroEC.dispose();
    cityEC.dispose();
    cidadeEC.dispose();
  }

  String? uf;

  void onChangedCep(cep) async {
    if (cep.isEmpty) {
      setState(() {
        isCepAutoCompleted = false;
      });
    } else if (cep.length == 8) {
      final viaCepSearchCep = ViaCepSearchCep();
      final infoCepJSON = await viaCepSearchCep.searchInfoByCep(cep: cep);
      infoCepJSON.fold(
        (error) {
          log('Erro ao buscar informações do CEP: $error');
        },
        (infoCepJSON) {
          setState(() {
            logradouroEC.text = infoCepJSON.logradouro ?? '';
            bairroEC.text = infoCepJSON.bairro ?? '';
            cidadeEC.text = infoCepJSON.localidade ?? '';
            uf = infoCepJSON.uf ?? '';
            isCepAutoCompleted = true;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spaceRegister = ref.watch(newSpaceRegisterVmProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      //backgroundColor: Colors.brown,
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
          'Cadastrar',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: const Color(0xffF8F8F8),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Onde fica seu espaço?',
                      style: TextStyle(
                        color: Color(0xff4300B1),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                          'Seu endereço só é confirmado com o locatário depois que a reserva é confirmada.'),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    myRow(
                      validator: spaceRegister.validateCEP(),
                      label: 'CEP',
                      controller: cepEC,
                      onChanged: onChangedCep,
                      //enable: isEditing,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    myRow(
                      validator: spaceRegister.validateLogradouro(),
                      label: 'Logradouro',
                      controller: logradouroEC,
                      onChanged: onChangedCep,
                      //enable: isEditing,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    myRow(
                      validator: spaceRegister.validateNumero(),
                      label: 'Número',
                      controller: numeroEC,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    myRow(
                      validator: spaceRegister.validateBairro(),
                      label: 'Bairro',
                      controller: bairroEC,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    myRow(
                      validator: spaceRegister.validateCidade(),
                      label: 'Cidade',
                      controller: cidadeEC,
                      enabled: !isCepAutoCompleted,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
              key: Keys.k3creenButton,
              onTap: () async {
                final stringResponse = await spaceRegister.validateForm(
                  context,
                  formKey,
                  cepEC,
                  logradouroEC,
                  numeroEC,
                  bairroEC,
                  cidadeEC,
                  uf,
                );
                if (stringResponse != null) {
                  Messages.showError(stringResponse, context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServicosAcomodacoes(),
                    ),
                  );
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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/servicos_acomodacoes.dart';
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
          'Cadastro de espaço',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Onde fica seu espaço?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Text(
                      'Seu endereço só é compartilhado com os hospedes depois que a reserva é confirmada'),
                  TextFormField(
                    controller: cepEC,
                    validator: spaceRegister.validateCEP(),
                    decoration: const InputDecoration(
                      hintText: 'CEP',
                    ),
                    onChanged: onChangedCep,
                  ),
                  TextFormField(
                    //enabled: !isCepAutoCompleted,
                    controller: logradouroEC,
                    validator: spaceRegister.validateLogradouro(),
                    decoration: const InputDecoration(
                      hintText: 'Logradouro',
                    ),
                  ),
                  TextFormField(
                    controller: numeroEC,
                    validator: spaceRegister.validateNumero(),
                    decoration: const InputDecoration(
                      hintText: 'Número',
                    ),
                  ),
                  TextFormField(
                    //enabled: !isCepAutoCompleted,
                    controller: bairroEC,
                    validator: spaceRegister.validateBairro(),
                    decoration: const InputDecoration(
                      hintText: 'Bairro',
                    ),
                  ),
                  TextFormField(
                    enabled: !isCepAutoCompleted,
                    controller: cidadeEC,
                    validator: spaceRegister.validateCidade(),
                    decoration: const InputDecoration(
                      hintText: 'Cidade',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Voltar',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final stringResponse = await spaceRegister.validateForm(
                        context,
                        formKey,
                        cepEC,
                        logradouroEC,
                        numeroEC,
                        bairroEC,
                        cidadeEC,
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
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: const Text(
                        'Avançar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

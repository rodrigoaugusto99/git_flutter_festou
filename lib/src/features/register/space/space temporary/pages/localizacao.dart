import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_state.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/servicos_acomodacoes.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_vm.dart';

import 'package:git_flutter_festou/src/models/address_model.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      'Salvar e sair',
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      'Dúvidas?',
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                    await spaceRegister.validateForm(
                      context,
                      formKey,
                      cepEC,
                      logradouroEC,
                      numeroEC,
                      bairroEC,
                      cidadeEC,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServicosAcomodacoes(),
                      ),
                    );
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
    );
  }
}

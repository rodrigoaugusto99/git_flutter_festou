import 'dart:developer';
import 'package:field_suggestion/field_suggestion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_state.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/pages/new_space_register.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/services_panel.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/place%20api/test.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/type_panel.dart';
import 'package:git_flutter_festou/src/features/register/space/widgets/weekdays_panel.dart';
import 'package:search_cep/search_cep.dart';

class EspacoRegisterPage extends ConsumerStatefulWidget {
  const EspacoRegisterPage({super.key});

  @override
  ConsumerState<EspacoRegisterPage> createState() => _EspacoRegisterPageState();
}

class _EspacoRegisterPageState extends ConsumerState<EspacoRegisterPage> {
  //final user = FirebaseAuth.instance.currentUser!;

  //controllers
  final formKey = GlobalKey<FormState>();

  final nomeEC = TextEditingController();
  final numeroEC = TextEditingController();
  final emailEC = TextEditingController();
  final cepEC = TextEditingController();
  final logradouroEC = TextEditingController();
  final bairroEC = TextEditingController();
  final cidadeEC = TextEditingController();
  final descricaoEC = TextEditingController();
  final cityEC = TextEditingController();
  bool isCepAutoCompleted = false;

  @override
  void dispose() {
    super.dispose();
    nomeEC.dispose();
    emailEC.dispose();
    numeroEC.dispose();
    cepEC.dispose();
    logradouroEC.dispose();
    bairroEC.dispose();
    descricaoEC.dispose();
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
    final spaceRegister = ref.read(spaceRegisterVmProvider.notifier);

    ref.listen(spaceRegisterVmProvider, (_, state) {
      switch (state) {
        case SpaceRegisterState(status: SpaceRegisterStateStatus.initial):
          break;
        case SpaceRegisterState(status: SpaceRegisterStateStatus.invalidForm):
          Messages.showError('Formulario invalido', context);
          break;
        case SpaceRegisterState(status: SpaceRegisterStateStatus.success):
          Navigator.of(context).pop();
          Messages.showSuccess('parabens', context);

        case SpaceRegisterState(
            status: SpaceRegisterStateStatus.error,
            :final errorMessage?
          ):
          Messages.showError(errorMessage, context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Criar card\nLogged in as: ${FirebaseAuth.instance.currentUser!.email}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  child: Text(
                    'Insira os dados do seu espaço!',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuickSearchScreen(),
                    ),
                  ),
                  child: const Text('oi'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewSpaceRegister(),
                    ),
                  ),
                  child: const Text('NewSpaceRegister()'),
                ),
                TextFormField(
                  controller: nomeEC,
                  validator: spaceRegister.validateNome(),
                  decoration: const InputDecoration(
                    hintText: 'nome',
                  ),
                ),
                TextFormField(
                  controller: emailEC,
                  validator: spaceRegister.validateEmail(),
                  decoration: const InputDecoration(
                    hintText: 'email',
                  ),
                ),
                TextFormField(
                  controller: cepEC,
                  validator: spaceRegister.validateCEP(),
                  decoration: const InputDecoration(
                    hintText: 'CEP',
                  ),
                  onChanged: onChangedCep,
                ),
                TextFormField(
                  enabled: !isCepAutoCompleted,
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
                  enabled: !isCepAutoCompleted,
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
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => spaceRegister.pickImage(),
                  child: const Text('upload photo'),
                ),
                WeekDaysPanel(
                  text: 'Selecione os DIAS da semana',
                  onDayPressed: (value) {
                    log('onDayPressed: $value');
                    spaceRegister.addOrRemoveAvailableDay(value);
                  },
                  availableDays: const [],
                ),
                TypePanel(
                  text: 'Selecione o TIPO de espaço',
                  onTypePressed: (value) {
                    log('onTypePressed: $value');
                    spaceRegister.addOrRemoveType(value);
                  },
                  selectedTypes: const [],
                ),
                ServicesPanel(
                  text: 'Selecione os SERVIÇOS do espaço',
                  onServicePressed: (value) {
                    log('onServicePressed: $value');
                    spaceRegister.addOrRemoveService(value);
                  },
                  selectedServices: const [],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await spaceRegister.validateForm(
                          context,
                          formKey,
                          nomeEC,
                          emailEC,
                          cepEC,
                          logradouroEC,
                          numeroEC,
                          bairroEC,
                          cidadeEC,
                          descricaoEC,
                          cityEC,
                        );
                      },
                      child: const Text('cadastrar espaco'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

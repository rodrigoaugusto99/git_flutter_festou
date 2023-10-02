import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/features/register/space/space_register_vm.dart';
import 'package:git_flutter_festou/src/features/register/widgets/options_panel.dart';
import 'package:git_flutter_festou/src/features/register/widgets/servicos_painel.dart';
import 'package:git_flutter_festou/src/features/register/widgets/tipo_painel.dart';
import 'package:search_cep/search_cep.dart';
import 'package:validatorless/validatorless.dart';

class EspacoRegisterPage extends ConsumerStatefulWidget {
  const EspacoRegisterPage({super.key});

  @override
  ConsumerState<EspacoRegisterPage> createState() => _EspacoRegisterPageState();
}

class _EspacoRegisterPageState extends ConsumerState<EspacoRegisterPage> {
  final user = FirebaseAuth.instance.currentUser!;

  //controllers
  final formKey = GlobalKey<FormState>();

  final nomeEC = TextEditingController();
  final numeroEC = TextEditingController();
  final emailEC = TextEditingController();
  final cepEC = TextEditingController();
  final enderecoEC = TextEditingController();
  final bairroEC = TextEditingController();
  final cidadeEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nomeEC.dispose();
    emailEC.dispose();
    numeroEC.dispose();
    cepEC.dispose();
    enderecoEC.dispose();
    bairroEC.dispose();
    cidadeEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spaceRegister = ref.watch(spaceRegisterVmProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Criar card\nLogged in as: ${user.email}'),
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
                TextFormField(
                  controller: nomeEC,
                  validator: Validatorless.required('Nome obrigatorio'),
                  decoration: const InputDecoration(
                    hintText: 'nome',
                  ),
                ),
                TextFormField(
                  controller: emailEC,
                  validator: Validatorless.email('email invalido'),
                  decoration: const InputDecoration(
                    hintText: 'email',
                  ),
                ),
                TextFormField(
                  controller: cepEC,
                  validator: Validatorless.required('cep obrigatorio'),
                  decoration: const InputDecoration(
                    hintText: 'CEP',
                  ),
                  onChanged: (cep) async {
                    if (cep.length == 8) {
                      final viaCepSearchCep = ViaCepSearchCep();
                      final infoCepJSON =
                          await viaCepSearchCep.searchInfoByCep(cep: cep);
                      infoCepJSON.fold(
                        (error) {
                          log('Erro ao buscar informações do CEP: $error');
                        },
                        (infoCepJSON) {
                          setState(() {
                            enderecoEC.text = infoCepJSON.logradouro ?? '';
                            bairroEC.text = infoCepJSON.bairro ?? '';
                            cidadeEC.text = infoCepJSON.localidade ?? '';
                          });
                        },
                      );
                    }
                  },
                ),
                TextFormField(
                  controller: enderecoEC,
                  validator: Validatorless.required('endereço obrigatorio'),
                  decoration: const InputDecoration(
                    hintText: 'Endereço',
                  ),
                ),
                TextFormField(
                  controller: numeroEC,
                  validator: Validatorless.required('numero obrigatorio'),
                  decoration: const InputDecoration(
                    hintText: 'Número',
                  ),
                ),
                TextFormField(
                  controller: bairroEC,
                  validator: Validatorless.required('bairro obrigatorio'),
                  decoration: const InputDecoration(
                    hintText: 'Bairro',
                  ),
                ),
                TextFormField(
                  controller: cidadeEC,
                  validator: Validatorless.required('cidade obrigatorio'),
                  decoration: const InputDecoration(
                    hintText: 'Cidade',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                WeekDaysPanel(
                  onDayPressed: (value) {
                    log('onDayPressed: $value');
                    spaceRegister.addOrRemoveAvailableDay(value);
                  },
                ),
                TipoPanel(
                  onTypePressed: (value) {
                    log('onTypePressed: $value');
                    spaceRegister.addOrRemoveType(value);
                  },
                ),
                ServicoPanel(
                  onServicePressed: (value) {
                    log('onServicePressed: $value');
                    spaceRegister.addOrRemoveService(value);
                  },
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
                      onPressed: () => spaceRegister.register(
                        nomeEC.text,
                        emailEC.text,
                        cepEC.text,
                        enderecoEC.text,
                        numeroEC.text,
                        bairroEC.text,
                        cidadeEC.text,
                      ),
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

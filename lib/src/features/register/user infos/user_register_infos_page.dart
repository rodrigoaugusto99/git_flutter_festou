import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/user%20infos/user_register_infos_vm.dart';
import 'package:git_flutter_festou/src/features/register/user%20infos/widgets/avatar_widget.dart';
import 'package:search_cep/search_cep.dart';
import 'package:validatorless/validatorless.dart';

class UserRegisterInfosPage extends ConsumerStatefulWidget {
  const UserRegisterInfosPage({super.key});

  @override
  ConsumerState<UserRegisterInfosPage> createState() =>
      _UserRegisterInfosPageState();
}

class _UserRegisterInfosPageState extends ConsumerState<UserRegisterInfosPage> {
  final fullNameEC = TextEditingController();
  final telefoneEC = TextEditingController();
  final cepEC = TextEditingController();
  final logradouroEC = TextEditingController();
  final bairroEC = TextEditingController();
  final cidadeEC = TextEditingController();
  bool isCepAutoCompleted = false;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    //Limpeza do controller
    fullNameEC.dispose();
    telefoneEC.dispose();
    cepEC.dispose();
    logradouroEC.dispose();
    bairroEC.dispose();
    cidadeEC.dispose();
    super.dispose();
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
    final userRegisterInfosVM = ref.watch(userRegisterInfosVmProvider.notifier);

    ref.listen(userRegisterInfosVmProvider, (_, state) {
      switch (state) {
        case UserRegisterInfosStateStatus.initial:
          break;
        case UserRegisterInfosStateStatus.success:
          Navigator.of(context).pushReplacementNamed('/home');
        case UserRegisterInfosStateStatus.error:
          Messages.showError(
              'Erro ao registrar informações do usuario', context);
        case UserRegisterInfosStateStatus.invalidForm:
          Messages.showError('Formulario invalido', context);
          break;
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Form(
          key: formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      const AvatarWidget(),
                      const SizedBox(height: 24),
                      TextFormField(
                        validator: userRegisterInfosVM.validateNome(),
                        decoration: const InputDecoration(
                          hintText: 'Nome completo',
                        ),
                        controller: fullNameEC,
                      ),

                      const SizedBox(height: 10),

                      //password textfield
                      TextFormField(
                        validator: Validatorless.required('Campo obrigatório'),
                        decoration: const InputDecoration(
                          hintText: 'Celular',
                        ),
                        controller: telefoneEC,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: cepEC,
                        validator: userRegisterInfosVM.validateCEP(),
                        decoration: const InputDecoration(
                          hintText: 'CEP',
                        ),
                        onChanged: onChangedCep,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        enabled: !isCepAutoCompleted,
                        validator: userRegisterInfosVM.validateLogradouro(),
                        decoration: const InputDecoration(
                          hintText: 'logradouro',
                        ),
                        controller: logradouroEC,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        enabled: !isCepAutoCompleted,
                        validator: userRegisterInfosVM.validateBairro(),
                        decoration: const InputDecoration(
                          hintText: 'bairro',
                        ),
                        controller: bairroEC,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        enabled: !isCepAutoCompleted,
                        validator: userRegisterInfosVM.validateCidade(),
                        decoration: const InputDecoration(
                          hintText: 'cidade',
                        ),
                        controller: cidadeEC,
                      ),
                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () async {
                          // Chama a função addUserInfos com os dados desejados
                          await userRegisterInfosVM.validateForm(
                              context,
                              formKey,
                              fullNameEC.text,
                              telefoneEC.text,
                              cepEC.text,
                              logradouroEC.text,
                              bairroEC.text,
                              cidadeEC.text);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                          foregroundColor: Colors.white,
                          backgroundColor: ColorsConstants.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Cadastrar dados'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

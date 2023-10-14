import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/user%20infos/user_register_infos_vm.dart';
import 'package:git_flutter_festou/src/features/register/user%20infos/widgets/avatar_widget.dart';
import 'package:git_flutter_festou/src/features/register/user/user_register_vm.dart';
import 'package:validatorless/validatorless.dart';

class UserRegisterInfosPage extends ConsumerStatefulWidget {
  const UserRegisterInfosPage({super.key});

  @override
  ConsumerState<UserRegisterInfosPage> createState() =>
      _UserRegisterInfosPageState();
}

class _UserRegisterInfosPageState extends ConsumerState<UserRegisterInfosPage> {
  final user = FirebaseAuth.instance.currentUser!;
  //text editing controllers

  final fullNameEC = TextEditingController();
  final telefoneEC = TextEditingController();
  final cepEC = TextEditingController();
  final logradouroEC = TextEditingController();
  /*necessarios apenas quando o cliente de fato alugar um espaço  
  final numeroEC = TextEditingController();
  final complementoEC = TextEditingController();*/
  final bairroEC = TextEditingController();
  final cidadeEC = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final userRegisterInfosVM = ref.watch(userRegisterInfosVmProvider.notifier);

    ref.listen(userRegisterInfosVmProvider, (_, state) {
      switch (state) {
        case UserRegisterInfosStateStatus.initial:
        case UserRegisterInfosStateStatus.success:
          Navigator.of(context).pushReplacementNamed('/home');
        case UserRegisterInfosStateStatus.error:
          Messages.showError(
              'Erro ao registrar informações do usuario', context);
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
                      AvatarWidget(),
                      const SizedBox(height: 24),
                      TextFormField(
                        validator: Validatorless.required('Campo obrigatório'),
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
                        validator: Validatorless.required('Campo obrigatório'),
                        decoration: const InputDecoration(
                          hintText: 'cep',
                        ),
                        controller: cepEC,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: Validatorless.required('Campo obrigatório'),
                        decoration: const InputDecoration(
                          hintText: 'logradouro',
                        ),
                        controller: logradouroEC,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: Validatorless.required('Campo obrigatório'),
                        decoration: const InputDecoration(
                          hintText: 'bairro',
                        ),
                        controller: bairroEC,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        validator: Validatorless.required('Campo obrigatório'),
                        decoration: const InputDecoration(
                          hintText: 'cidade',
                        ),
                        controller: cidadeEC,
                      ),
                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () async {
                          // Chama a função addUserInfos com os dados desejados
                          await userRegisterInfosVM.register(
                              user: user,
                              name: fullNameEC.text,
                              telefone: telefoneEC.text,
                              cep: cepEC.text,
                              logradouro: logradouroEC.text,
                              bairro: bairroEC.text,
                              cidade: cidadeEC.text);
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

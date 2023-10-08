import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/features/register/user%20infos/widgets/avatar_widget.dart';
import 'package:validatorless/validatorless.dart';

class UserRegisterInfosPage extends ConsumerStatefulWidget {
  const UserRegisterInfosPage({super.key});

  @override
  ConsumerState<UserRegisterInfosPage> createState() =>
      _UserRegisterInfosPageState();
}

class _UserRegisterInfosPageState extends ConsumerState<UserRegisterInfosPage> {
  //text editing controllers

  final fullNameEC = TextEditingController();
  final phoneNumberEC = TextEditingController();
  final userLocationEC = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    //Limpeza do controller
    fullNameEC.dispose();
    phoneNumberEC.dispose();
    userLocationEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        controller: phoneNumberEC,
                      ),

                      const SizedBox(height: 10),

                      //confirm password textfield
                      TextFormField(
                        validator: Validatorless.required('CEP obrigatório'),
                        decoration: const InputDecoration(
                          hintText: 'Seu CEP',
                        ),
                        controller: userLocationEC,
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: () {},
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

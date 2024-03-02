import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker_widget/date_picker.dart';
import 'package:flutter_holo_date_picker_widget/i18n/date_picker_i18n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
import 'package:git_flutter_festou/src/features/register/user/user_register_vm.dart';

class UserRegisterPage extends ConsumerStatefulWidget {
  const UserRegisterPage({super.key});

  @override
  ConsumerState<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends ConsumerState<UserRegisterPage> {
  //text editing controllers

  final emailEC = TextEditingController();
  final cpfEC = TextEditingController();
  final nameEC = TextEditingController();
  final passwordEC = TextEditingController();
  final confirmPasswordEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    //Limpeza do controller
    emailEC.dispose();
    cpfEC.dispose();
    nameEC.dispose();
    passwordEC.dispose();
    confirmPasswordEC.dispose();
    super.dispose();
  }

  bool isVisible = false;
  bool confirmIsVisible = false;

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final userRegisterVM = ref.watch(userRegisterVmProvider.notifier);

    ref.listen(userRegisterVmProvider, (_, state) {
      switch (state) {
        case UserRegisterStateStatus.initial:
          break;
        case UserRegisterStateStatus.success:
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/emailVerification', (route) => false);
        case UserRegisterStateStatus.registrationError:
          Messages.showError('Erro ao registrar usuário', context);
        case UserRegisterStateStatus.formInvalid:
          Messages.showError('Formulário inválido', context);
      }
    });

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    //final double loginButtonWidth = (115 / 412) * screenWidth;
    //final double loginButtonHeight = (31 / 732) * screenHeight;

    final double googleLoginButtonWidth = (202 / 412) * screenWidth;
    final double googleLoginButtonHeight = (37 / 732) * screenHeight;

    final double firstContainer = (179 / 732) * screenHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: firstContainer,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          ImageConstants.serpentinae,
                        ),
                        SizedBox(
                          height: screenHeight * 0.12,
                          child: Stack(
                            children: [
                              const Text(
                                'FESTOU',
                                style: TextStyle(
                                  fontFamily: 'NerkoOne',
                                  fontSize: 60,
                                  color: Color.fromARGB(255, 13, 46, 89),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: screenWidth * 0.11,
                                child: const Text(
                                  'Cadastro',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Marcellus',
                                    color: Color.fromARGB(255, 13, 46, 89),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          ImageConstants.serpentinad,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CPF/CNPJ:',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        TextFormField(
                          controller: cpfEC,
                          validator: userRegisterVM.validateCpf(),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                            hintText: 'Digite aqui seu documento',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 9),
                            //border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                          ),
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'E-mail:',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        TextFormField(
                          controller: emailEC,
                          validator: userRegisterVM.validateEmail(),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                            hintText: 'Digite aqui seu e-mail',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 9),
                            //border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                          ),
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Nome:',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        TextFormField(
                          controller: nameEC,
                          validator: userRegisterVM.validateName(),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                            hintText: 'Digite aqui seu nome',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 9),
                            //border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                          ),
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Senha:',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        TextFormField(
                          controller: passwordEC,
                          validator: userRegisterVM.validatePassword(),
                          decoration: const InputDecoration(
                            /*suffixIcon: GestureDetector(
                              onTap: () => setState(
                                () {
                                  isVisible = !isVisible;
                                },
                              ),
                              child: isVisible
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),*/
                            contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                            hintText: 'Digite aqui sua senha',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 9),
                            //border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                          ),
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Confirme sua senha:',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        TextFormField(
                          controller: confirmPasswordEC,
                          validator: userRegisterVM.confirmPassword(passwordEC),
                          decoration: const InputDecoration(
                            /*suffixIcon: GestureDetector(
                              onTap: () => setState(
                                () {
                                  isVisible = !isVisible;
                                },
                              ),
                              child: isVisible
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),*/
                            contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                            hintText: 'Digite sua senha novamente',
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 9),
                            //border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                          ),
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black),
                        ),
                        SizedBox(height: screenHeight * 0.1),
                        Align(
                          child: InkWell(
                            onTap: () {
                              userRegisterVM.validateForm(context, formKey,
                                  emailEC, passwordEC, nameEC, cpfEC);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: googleLoginButtonWidth,
                              height: googleLoginButtonHeight,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 13, 46, 89),

                                borderRadius: BorderRadius.circular(
                                    10), // Borda arredondada
                              ),
                              child: const Text(
                                'CADASTRAR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Align(
                          child: InkWell(
                            onTap: () =>
                                Navigator.of(context).pushNamed('/login'),
                            child: Container(
                              alignment: Alignment.center,
                              width: googleLoginButtonWidth,
                              height: googleLoginButtonHeight,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 13, 46, 89),
                                borderRadius: BorderRadius.circular(
                                    10), // Borda arredondada
                              ),
                              child: const Text(
                                'VOLTAR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:validatorless/validatorless.dart';

part 'user_register_vm.g.dart';

enum UserRegisterStateStatus {
  initial,
  success,
  formInvalid,
  registrationError,
}

@riverpod
class UserRegisterVm extends _$UserRegisterVm {
  //método build
  @override
  UserRegisterStateStatus build() => UserRegisterStateStatus.initial;

  //validação email
  FormFieldValidator<String> validateName() {
    return Validatorless.multiple([
      Validatorless.required('Nome obrigatorio'),
    ]);
  }

  //validação email
  FormFieldValidator<String> validateCpf() {
    return Validatorless.multiple([
      Validatorless.required('CPF obrigatorio'),
      Validatorless.cpf('CPF invalido')
    ]);
  }

  //validação email
  FormFieldValidator<String> validateEmail() {
    return Validatorless.multiple([
      Validatorless.required('Email obrigatorio'),
      Validatorless.email('Email invalido')
    ]);
  }

//validação senha
  FormFieldValidator<String> validatePassword() {
    return Validatorless.multiple([
      Validatorless.required('Senha obrigatoria'),
      Validatorless.min(6, 'Senha deve ter no minimo 6 caracteres'),
    ]);
  }

//confirmação senha
  FormFieldValidator<String> confirmPassword(TextEditingController passwordEC) {
    return Validatorless.multiple([
      Validatorless.required('Confirme sua senha'),
      Validatorless.min(6, 'Senha deve ter no minimo 6 caracteres'),
      Validatorless.compare(passwordEC, 'Senha precisam ser iguais')
    ]);
  }

  void validateForm(
      BuildContext context, formKey, emailEC, passwordEC, nameEC, cpfEC) {
    if (formKey.currentState?.validate() == true) {
      register(
        email: emailEC.text,
        password: passwordEC.text,
        name: nameEC.text,
        cpf: cpfEC.text,
      );
    } else {
      state = UserRegisterStateStatus.formInvalid;
    }
  }

//metódo de registro
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String cpf,
  }) async {
    final userRegisterService = ref.watch(userRegisterServiceProvider);

    final userData = (
      email: email,
      password: password,
      name: name,
      cpf: cpf,
    );

    final registerResult = await userRegisterService.execute(userData);
    switch (registerResult) {
      case Success():
        state = UserRegisterStateStatus.success;
      case Failure():
        state = UserRegisterStateStatus.registrationError;
    }
  }
}

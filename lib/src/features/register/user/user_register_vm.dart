import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:git_flutter_festou/src/core/ui/helpers/messages.dart';
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

  Future<String?> checkIfCpfExists(String cpf) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      QuerySnapshot querySnapshot =
          await users.where('cpf', isEqualTo: cpf).get();

      if (querySnapshot.docs.isNotEmpty) {
        return 'Esse CPF já foi cadastrado.';
      } else {
        return null;
      }
    } catch (e) {
      log('Erro ao buscar usuário por CPF: $e');
      return null;
    }
  }

  Future<String?> checkIfEmailExists(String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        return 'E-mail já cadastrado.';
      } else {
        return null;
      }
    } catch (e) {
      log('Erro ao buscar usuário por e-mail: $e');
      return null;
    }
  }

  //validação email
  FormFieldValidator<String> validateCpf() {
    return Validatorless.multiple([
      Validatorless.required('CPF obrigatorio'),
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
      Validatorless.required('Senha obrigatória'),
      Validatorless.min(6, 'Senha deve ter no mínimo 6 caracteres'),
      (value) {
        if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value!)) {
          return 'Senha deve conter pelo menos uma letra maiúscula';
        }
        if (!RegExp(r'^(?=.*[a-z])').hasMatch(value)) {
          return 'Senha deve conter pelo menos uma letra minúscula';
        }
        if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
          return 'Senha deve conter pelo menos um número';
        }
        if (!RegExp(r'^(?=.*[@$!%*?&])').hasMatch(value)) {
          return 'Senha deve conter pelo menos um caractere especial (@, \$, !, %, *, ?, &)';
        }
        return null;
      },
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
      BuildContext context, formKey, emailEC, passwordEC, nameEC, cpfEC) async {
    if (formKey.currentState?.validate() == true) {
      final response = await checkIfCpfExists(cpfEC.text);
      if (response != null) {
        Messages.showError(response, context);
        return;
      }
      if (cpfEC.text.length != 14 && cpfEC.text.length != 18) {
        Messages.showError('CPF ou CNPJ inválidos.', context);
        return;
      }
      final response2 = await checkIfEmailExists(emailEC.text);
      if (response2 != null) {
        Messages.showError(response2, context);
        return;
      }
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
    //log(registerResult..toString(), name: 'registerResult');
    switch (registerResult) {
      case Success():
        state = UserRegisterStateStatus.success;
      case Failure():
        state = UserRegisterStateStatus.registrationError;
    }
  }
}

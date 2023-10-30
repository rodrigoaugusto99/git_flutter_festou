import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/exceptions/auth_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:validatorless/validatorless.dart';

import 'login_state.dart';

part 'login_vm.g.dart';

@riverpod
class LoginVM extends _$LoginVM {
  @override
  LoginState build() => LoginState.initial();

  //validação email
  FormFieldValidator<String> validateEmail() {
    return Validatorless.multiple([
      Validatorless.required('Email obrigatorio'),
      Validatorless.email('mail invalido')
    ]);
  }

//validação senha
  FormFieldValidator<String> validatePassword() {
    return Validatorless.multiple([
      Validatorless.required('Senha obrigatoria'),
      Validatorless.min(6, 'Senha deve ter no minimo 6 caracteres'),
    ]);
  }

  void validateForm(BuildContext context, formKey, emailEC, passwordEC) {
    if (formKey.currentState?.validate() == true) {
      login(
        emailEC.text,
        passwordEC.text,
      );
    } else {
      state = LoginState(status: LoginStateStatus.invalidForm);
    }
  }

  Future<void> login(String email, String password) async {
    final userAuthRepository = ref.watch(userAuthRepositoryProvider);

    final loginResult = await userAuthRepository.login(email, password);

    switch (loginResult) {
      case Success():
        state = state.copyWith(status: LoginStateStatus.userLogin);
        break;
      case Failure(exception: AuthError(:final message)):
        state = state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: () => message,
        );
    }
  }
}

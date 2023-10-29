import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:validatorless/validatorless.dart';

part 'user_register_infos_vm.g.dart';

enum UserRegisterInfosStateStatus {
  initial,
  success,
  invalidForm,
  error,
}

@riverpod
class UserRegisterInfosVm extends _$UserRegisterInfosVm {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  UserRegisterInfosStateStatus build() => UserRegisterInfosStateStatus.initial;

  FormFieldValidator<String> validateNome() {
    return Validatorless.required('Nome obrigatorio');
  }

  FormFieldValidator<String> validateCEP() {
    return Validatorless.required('CEP obrigatorio');
  }

  FormFieldValidator<String> validateLogradouro() {
    return Validatorless.required('Logradouro obrigatorio');
  }

  FormFieldValidator<String> validateBairro() {
    return Validatorless.required('Bairro obrigatorio');
  }

  FormFieldValidator<String> validateCidade() {
    return Validatorless.required('Cidade obrigatorio');
  }

  Future<void> validateForm(
    BuildContext context,
    formKey,
    fullNameEC,
    telefoneEC,
    cepEC,
    logradouroEC,
    bairroEC,
    cidadeEC,
  ) async {
    if (formKey.currentState?.validate() == true) {
      await register(
        fullNameEC.text,
        telefoneEC.text,
        cepEC.text,
        logradouroEC.text,
        bairroEC.text,
        cidadeEC.text,
      );
    } else {
      state = UserRegisterInfosStateStatus.invalidForm;
    }
  }

  Future<void> register(
    String name,
    String telefone,
    String cep,
    String logradouro,
    String bairro,
    String cidade,
  ) async {
    final userFirestoreRepository = ref.watch(userFirestoreRepositoryProvider);

    final userId = user.uid;
    final userData = (
      userId: userId,
      name: name,
      telefone: telefone,
      cep: cep,
      logradouro: logradouro,
      bairro: bairro,
      cidade: cidade,
    );

    final registerResult =
        await userFirestoreRepository.saveUserInfos(userData);
    switch (registerResult) {
      case Success():
        state = UserRegisterInfosStateStatus.success;
      case Failure():
        state = UserRegisterInfosStateStatus.error;
    }
  }
}

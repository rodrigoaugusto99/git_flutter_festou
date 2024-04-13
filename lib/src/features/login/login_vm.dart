import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/exceptions/auth_exception.dart';
import 'package:git_flutter_festou/src/core/fp/either.dart';
import 'package:git_flutter_festou/src/core/providers/application_providers.dart';

import 'package:git_flutter_festou/src/services/auth_services.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:validatorless/validatorless.dart';

import 'login_state.dart';

part 'login_vm.g.dart';

@riverpod
class LoginVM extends _$LoginVM {
  String dialogMessage = '';
  @override
  LoginState build() => LoginState.initial();

  //validação email
  FormFieldValidator<String> validateEmail() {
    return Validatorless.multiple([]);
  }

//validação senha
  FormFieldValidator<String> validatePassword() {
    return Validatorless.multiple([]);
  }

  String validateAll(code, email, password) {
    String errorMessage;

    if (email.isEmpty || email == '' || code == 'invalid-email') {
      errorMessage = 'E-mail inválido!';
    } else if (password.isEmpty || password == '') {
      errorMessage = 'Senha não informada!';
    } else if (code == 'INVALID_LOGIN_CREDENTIALS') {
      errorMessage = 'E-mail ou senha inválidos.';
    } else {
      errorMessage = 'Erro ao realizar login';
    }
    return errorMessage;
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
        ref.invalidate(userFirestoreRepositoryProvider);
        ref.invalidate(userAuthRepositoryProvider);
        ref.invalidate(spaceFirestoreRepositoryProvider);
        ref.invalidate(imagesStorageRepositoryProvider);
        ref.invalidate(feedbackFirestoreRepositoryProvider);
        ref.invalidate(reservationFirestoreRepositoryProvider);
        state = state.copyWith(status: LoginStateStatus.userLogin);
        break;
      case Failure(exception: AuthError(:final message)):
        state = state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: () => message,
        );
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    final useFirestoreRepository = ref.watch(userFirestoreRepositoryProvider);

    final result = await AuthService(context: context).signInWithGoogle();

//pega o valor de hasPassword de lá
    bool isNew = true;

    switch (result) {
      case Success(value: final userCredential):

/**o intuito desse if é verificar se, ao logar com google, ja tiver um  provedor com aquele email. 
 * inicialmente, se tiveesse, ele teria sido criado pelo email/senha, mas se ocorreu o caso de 
 * ter provedor do google unico e desvincular, então realmente nao vai ter provedor com aquele email,
 * mas como essa verificacao leva em conta apenas
*/
        // Verificar se o e-mail já está registrado no Firebase Auth(pelo email/senha)
        if (userCredential.additionalUserInfo!.isNewUser) {
          // Não há e-mail igual no banco
          log("Novo usuário registrado");
          final user = userCredential.user!;
          final dto = (
            id: user.uid.toString(),
            email: user.email.toString(),
            /*logando com google, nao sera colocado name e cpf. 
            no futuro sera pedido caso precise */
            name: '',
            cpf: '',
          );
          await useFirestoreRepository.saveUser(dto);
        } else {
          // O usuário já estava registrado anteriormente com email/senha ou GOOGLE
          log("Usuário não é novo");
          isNew = false;
        }
        state = state.copyWith(
            status: LoginStateStatus.userLogin, isNew: () => isNew);

        break;
      case Failure(exception: AuthError(:final message)):
        state = state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: () => message,
        );
    }
  }
}

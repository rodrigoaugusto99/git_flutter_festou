import 'package:flutter/material.dart';

enum LoginStateStatus {
  initial,
  error,
  userLogin,
  invalidForm,
}

class LoginState {
  final LoginStateStatus status;
  final String? errorMessage;
  final String? dialogMessage;
  final bool? isNew;

  LoginState.initial() : this(status: LoginStateStatus.initial);

  LoginState(
      {required this.status,
      this.errorMessage,
      this.dialogMessage,
      this.isNew});

  LoginState copyWith(
      {LoginStateStatus? status,
      ValueGetter<String?>? errorMessage,
      ValueGetter<String?>? dialogMessage,
      ValueGetter<bool?>? isNew}) {
    return LoginState(
        status: status ?? this.status,
        errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
        dialogMessage:
            dialogMessage != null ? dialogMessage() : this.dialogMessage,
        isNew: isNew != null ? isNew() : this.isNew);
  }
}

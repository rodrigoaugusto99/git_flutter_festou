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

  LoginState.initial() : this(status: LoginStateStatus.initial);

  LoginState({
    required this.status,
    this.errorMessage,
    this.dialogMessage,
  });

  LoginState copyWith({
    LoginStateStatus? status,
    ValueGetter<String?>? errorMessage,
    ValueGetter<String?>? dialogMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      dialogMessage:
          dialogMessage != null ? dialogMessage() : this.dialogMessage,
    );
  }
}

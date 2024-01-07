/*sealed class, nao pode ser instanciada, vai ser util para fazermos o pattern matchign, 
para podemos idetnificar com o switch, qual é o erro.( no caso, AuthError ou UnAuthorizedException) */

sealed class AuthException implements Exception {
  final String message;
  AuthException({required this.message});
}

class AuthError extends AuthException {
  AuthError({required super.message});
}

/*class AuthUnauthorizedException extends AuthException {
  AuthUnauthorizedException() : super(message: '');
}*/

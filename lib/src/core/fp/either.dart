sealed class Either<E extends Exception, S> {}

/*conceito do Either

 nao vai ter excecoes subindo no sistema. vamos trabalahr 
 com uma estrutura que vai retornar um erro E um sucesso*/
class Failure<E extends Exception, S> extends Either<E, S> {
  final E exception;
  Failure(this.exception);
}

class Success<E extends Exception, S> extends Either<E, S> {
  final S value;
  Success(this.value);
}

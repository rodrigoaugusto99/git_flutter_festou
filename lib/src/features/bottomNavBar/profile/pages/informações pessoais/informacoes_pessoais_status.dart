import 'package:git_flutter_festou/src/models/user_model.dart';

enum InformacoesPessoaisStateStatus { loaded, error }

class InformacoesPessoaisState {
  final InformacoesPessoaisStateStatus status;
  final String nome;
  final String telefone;
  final String email;

  InformacoesPessoaisState(
      {required this.status,
      required this.nome,
      required this.telefone,
      required this.email});

  InformacoesPessoaisState copyWith(
      {InformacoesPessoaisStateStatus? status,
      String? nome,
      String? telefone,
      String? email}) {
    return InformacoesPessoaisState(
        status: status ?? this.status,
        nome: nome ?? this.nome,
        telefone: telefone ?? this.telefone,
        email: email ?? this.email);
  }
}

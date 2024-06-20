class UserModel {
  final String fantasyName;
  final String email;
  final String name;
  final String cpfOuCnpj;
  final String cep;
  final String logradouro;
  final String telefone;
  final String bairro;
  final String cidade;
  final String id;
  final String avatarUrl;
  late final bool locador;

  UserModel({
    required this.fantasyName,
    required this.email,
    required this.name,
    required this.cpfOuCnpj,
    required this.cep,
    required this.logradouro,
    required this.telefone,
    required this.bairro,
    required this.cidade,
    required this.id,
    required this.avatarUrl,
    required this.locador,
  });
}

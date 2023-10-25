class UserModel {
  final String id;
  final String email;
  final String name;
  final String cep;
  final String logradouro;
  final String telefone;
  final String bairro;
  final String cidade;

  UserModel(
    this.email,
    this.name,
    this.cep,
    this.logradouro,
    this.telefone,
    this.bairro,
    this.cidade,
    this.id,
  );
}

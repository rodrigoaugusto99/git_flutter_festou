class UserModel {
  final String id;
  final String email;
  final String name;
  final String cpf;
  final String cep;
  final String logradouro;
  final String telefone;
  final String bairro;
  final String cidade;
  final String doc1Url;
  final String doc2Url;
  final String avatarUrl;

  UserModel(
    this.email,
    this.name,
    this.cpf,
    this.cep,
    this.logradouro,
    this.telefone,
    this.bairro,
    this.cidade,
    this.id,
    this.doc1Url,
    this.doc2Url,
    this.avatarUrl,
  );
}

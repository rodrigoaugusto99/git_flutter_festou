class UserModel {
  final String fantasyName;
  final String email;
  final String name;
  final String cpf;
  final String cnpj;
  final String cep;
  final String logradouro;
  final String telefone;
  final String bairro;
  final String cidade;
  final String id;
  final String avatarUrl;
  final String estado;
  final String assinatura;
  late final bool locador;

  UserModel({
    required this.fantasyName,
    required this.email,
    required this.name,
    required this.cpf,
    required this.assinatura,
    required this.cnpj,
    required this.cep,
    required this.logradouro,
    required this.telefone,
    required this.bairro,
    required this.cidade,
    required this.id,
    required this.avatarUrl,
    required this.locador,
    required this.estado,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      fantasyName: data['fantasy_name'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      cpf: data['cpf'] ?? '',
      cnpj: data['cnpj'] ?? '',
      cep: data['cep'] ?? '',
      logradouro: data['logradouro'] ?? '',
      telefone: data['telefone'] ?? '',
      bairro: data['bairro'] ?? '',
      cidade: data['cidade'] ?? '',
      id: data['uid'] ?? '',
      avatarUrl: data['avatar_url'] ?? '',
      estado: data['estado'] ?? '',
      assinatura: data['assinatura'] ?? '',
      locador: data['locador'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fantasyName': fantasyName,
      'email': email,
      'name': name,
      'cpf': cpf,
      'cnpj': cnpj,
      'cep': cep,
      'logradouro': logradouro,
      'telefone': telefone,
      'bairro': bairro,
      'cidade': cidade,
      'assinatura': assinatura,
      'id': id,
      'avatar_url': avatarUrl,
      'locador': locador,
    };
  }
}

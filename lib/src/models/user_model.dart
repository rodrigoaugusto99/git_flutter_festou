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
  final String estado;
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
    required this.estado,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      fantasyName: data['fantasyName'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      cpfOuCnpj: data['cpfOuCnpj'] ?? '',
      cep: data['cep'] ?? '',
      logradouro: data['logradouro'] ?? '',
      telefone: data['telefone'] ?? '',
      bairro: data['bairro'] ?? '',
      cidade: data['cidade'] ?? '',
      id: documentId,
      avatarUrl: data['avatar_url'] ?? '',
      estado: data['estado'] ?? '',
      locador: data['locador'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fantasyName': fantasyName,
      'email': email,
      'name': name,
      'cpfOuCnpj': cpfOuCnpj,
      'cep': cep,
      'logradouro': logradouro,
      'telefone': telefone,
      'bairro': bairro,
      'cidade': cidade,
      'id': id,
      'avatar_url': avatarUrl,
      'locador': locador,
    };
  }
}

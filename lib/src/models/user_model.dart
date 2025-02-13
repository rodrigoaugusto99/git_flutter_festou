class UserModel {
  final String fantasyName;
  final String email;
  final String name;
  final String cpf;
  final String cnpj;
  final String cep;
  final String logradouro;
  final String numero;
  final String telefone;
  final String bairro;
  final String cidade;
  final String estado;
  final String uid;
  final String avatarUrl;
  final String assinatura;
  final String docId;
  late final bool locador;

  UserModel({
    required this.fantasyName,
    required this.email,
    required this.name,
    required this.cpf,
    required this.cnpj,
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.telefone,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.uid,
    required this.avatarUrl,
    required this.assinatura,
    required this.docId,
    required this.locador,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      fantasyName: data['fantasy_name'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      cpf: data['cpf'] ?? '',
      cnpj: data['cnpj'] ?? '',
      telefone: data['telefone'] ?? '',
      cep: data['user_address']['cep'] ?? '',
      logradouro: data['user_address']['logradouro'] ?? '',
      numero: data['user_address']['numero'] ?? '',
      bairro: data['user_address']['bairro'] ?? '',
      cidade: data['user_address']['cidade'] ?? '',
      estado: data['user_address']['estado'] ?? '',
      uid: data['uid'] ?? '',
      avatarUrl: data['avatar_url'] ?? '',
      assinatura: data['assinatura'] ?? '',
      docId: data['id'] ?? '',
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
      'numero': numero,
      'telefone': telefone,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'uid': uid,
      'avatar_url': avatarUrl,
      'assinatura': assinatura,
      'locador': locador,
    };
  }
}

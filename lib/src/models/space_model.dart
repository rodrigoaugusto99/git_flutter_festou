class SpaceModel {
  bool isFavorited;
  final String spaceId;
  final String userId;
  final String titulo;

  final String cep;
  final String logradouro;
  final String numero;
  final String bairro;
  final String cidade;
  final List<dynamic> selectedTypes;
  final List<dynamic> selectedServices;

  final String averageRating;
  final String numComments;
  final String locadorName;
  final String descricao;
  final String city;
  final List<String> imagesUrl;

  final double latitude;
  final double longitude;

  final String locadorAvatarUrl;
  final String startTime;
  final String endTime;
  final List<String> days;
  final String preco;

  final String cnpjEmpresaLocadora;
  final String estado;
  final String locadorCpf;
  final String nomeEmpresaLocadora;
  final String locadorAssinatura;

  SpaceModel({
    required this.isFavorited,
    required this.spaceId,
    required this.userId,
    required this.titulo,
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.selectedTypes,
    required this.selectedServices,
    required this.averageRating,
    required this.numComments,
    required this.locadorName,
    required this.descricao,
    required this.city,
    required this.imagesUrl,
    required this.latitude,
    required this.longitude,
    required this.locadorAvatarUrl,
    required this.startTime,
    required this.endTime,
    required this.days,
    required this.preco,
    required this.cnpjEmpresaLocadora,
    required this.estado,
    required this.locadorCpf,
    required this.nomeEmpresaLocadora,
    required this.locadorAssinatura,
  });
}

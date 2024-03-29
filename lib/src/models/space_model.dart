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

  SpaceModel(
    this.isFavorited,
    this.spaceId,
    this.userId,
    this.titulo,
    this.cep,
    this.logradouro,
    this.numero,
    this.bairro,
    this.cidade,
    this.selectedTypes,
    this.selectedServices,
    this.averageRating,
    this.numComments,
    this.locadorName,
    this.descricao,
    this.city,
    this.imagesUrl,
    this.latitude,
    this.longitude,
    this.locadorAvatarUrl,
  );
}

class SpaceModel {
  final bool isFavorited;
  final String spaceId;
  final String email;
  final String name;
  final String cep;
  final String logradouro;
  final String numero;
  final String bairro;
  final String cidade;
  final List<dynamic> selectedTypes;
  final List<dynamic> selectedServices;
  final List<dynamic> availableDays;

  SpaceModel(
    this.isFavorited,
    this.spaceId,
    this.email,
    this.name,
    this.cep,
    this.logradouro,
    this.numero,
    this.bairro,
    this.cidade,
    this.selectedTypes,
    this.selectedServices,
    this.availableDays,
  );
}

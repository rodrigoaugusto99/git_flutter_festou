import 'package:cloud_firestore/cloud_firestore.dart';

class Hours {
  Hours({
    required this.from,
    required this.to,
  });
  String from;
  String to;
  Map<String, String> toMap() {
    return {
      'from': from,
      'to': to,
    };
  }
}

class Days {
  Days({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });
  Hours? monday;
  Hours? tuesday;
  Hours? wednesday;
  Hours? thursday;
  Hours? friday;
  Hours? saturday;
  Hours? sunday;

  Map<String, dynamic> toMap() {
    return {
      'monday': monday?.toMap(),
      'tuesday': tuesday?.toMap(),
      'wednesday': wednesday?.toMap(),
      'thursday': thursday?.toMap(),
      'friday': friday?.toMap(),
      'saturday': saturday?.toMap(),
      'sunday': sunday?.toMap(),
    };
  }
}

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
  final List<String> videosUrl;

  final double latitude;
  final double longitude;

  final String locadorAvatarUrl;
  final String startTime;
  final String endTime;
  final String preco;

  final String cnpjEmpresaLocadora;
  final String estado;
  final String locadorCpf;
  final String nomeEmpresaLocadora;
  final String locadorAssinatura;
  final int numLikes;
  final Days? days;

  SpaceModel({
    required this.isFavorited,
    required this.days,
    required this.numLikes,
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
    required this.preco,
    required this.cnpjEmpresaLocadora,
    required this.estado,
    required this.locadorCpf,
    required this.nomeEmpresaLocadora,
    required this.locadorAssinatura,
    required this.videosUrl,
  });
}

Future<SpaceModel> mapSpaceDocumentToModel2(
  DocumentSnapshot spaceDocument,
  bool isFavorited,
) async {
  // Pegando os dados necessários antes de criar o card
  List<String> selectedTypes =
      List<String>.from(spaceDocument['selectedTypes'] ?? []);
  List<String> selectedServices =
      List<String>.from(spaceDocument['selectedServices'] ?? []);
  List<String> imagesUrl = List<String>.from(spaceDocument['images_url'] ?? []);

  String spaceId = spaceDocument.get('space_id');
  final averageRating = await getAverageRating(spaceId);
  final numComments = await getNumComments(spaceId);

  return SpaceModel(
    days: spaceDocument['weekdays'] == null
        ? null
        : Days(
            monday: Hours(
              from: spaceDocument['weekdays']['monday']['from'],
              to: spaceDocument['weekdays']['monday']['to'],
            ),
            tuesday: Hours(
              from: spaceDocument['weekdays']['tuesday']['from'],
              to: spaceDocument['weekdays']['tuesday']['to'],
            ),
            wednesday: Hours(
              from: spaceDocument['weekdays']['wednesday']['from'],
              to: spaceDocument['weekdays']['wednesday']['to'],
            ),
            thursday: Hours(
              from: spaceDocument['weekdays']['thursday']['from'],
              to: spaceDocument['weekdays']['thursday']['to'],
            ),
            friday: Hours(
              from: spaceDocument['weekdays']['friday']['from'],
              to: spaceDocument['weekdays']['friday']['to'],
            ),
            saturday: Hours(
              from: spaceDocument['weekdays']['saturday']['from'],
              to: spaceDocument['weekdays']['saturday']['to'],
            ),
            sunday: Hours(
              from: spaceDocument['weekdays']['sunday']['from'],
              to: spaceDocument['weekdays']['sunday']['to'],
            ),
          ),
    videosUrl: List<String>.from(spaceDocument['videos'] ?? []),
    isFavorited: isFavorited,
    spaceId: spaceDocument['space_id'] ?? '',
    userId: spaceDocument['user_id'] ?? '',
    titulo: spaceDocument['titulo'] ?? '',
    cep: spaceDocument['cep'] ?? '',
    logradouro: spaceDocument['logradouro'] ?? '',
    numero: spaceDocument['numero'] ?? '',
    bairro: spaceDocument['bairro'] ?? '',
    cidade: spaceDocument['cidade'] ?? '',
    selectedTypes: selectedTypes,
    selectedServices: selectedServices,
    averageRating: averageRating,
    numComments: numComments,
    locadorName: spaceDocument['locador_name'] ?? '',
    descricao: spaceDocument['descricao'] ?? '',
    city: spaceDocument['city'] ?? '',
    imagesUrl: imagesUrl,
    latitude: spaceDocument['latitude'] ?? 0.0,
    longitude: spaceDocument['longitude'] ?? 0.0,
    locadorAvatarUrl: spaceDocument['locadorAvatarUrl'] ?? '',
    startTime: spaceDocument['startTime'] ?? '',
    endTime: spaceDocument['endTime'] ?? '',
    preco: spaceDocument['preco'] ?? '',
    cnpjEmpresaLocadora: spaceDocument['cnpj_empresa_locadora'] ?? '',
    estado: spaceDocument['estado'] ?? '',
    locadorCpf: spaceDocument['locador_cpf'] ?? '',
    nomeEmpresaLocadora: spaceDocument['nome_empresa_locadora'] ?? '',
    locadorAssinatura: spaceDocument['locador_assinatura'] ?? '',
    numLikes: spaceDocument['num_likes'] ?? 0,
  );
}

Future<SpaceModel> mapSpaceDocumentToModel(
  QueryDocumentSnapshot spaceDocument,
  bool isFavorited,
) async {
  // Pegando os dados necessários antes de criar o card
  List<String> selectedTypes =
      List<String>.from(spaceDocument['selectedTypes'] ?? []);
  List<String> selectedServices =
      List<String>.from(spaceDocument['selectedServices'] ?? []);
  List<String> imagesUrl = List<String>.from(spaceDocument['images_url'] ?? []);
  // List<String> days = List<String>.from(spaceDocument['weekdays'] ?? []);

  String spaceId = spaceDocument.get('space_id');
  final averageRating = await getAverageRating(spaceId);
  final numComments = await getNumComments(spaceId);
  return SpaceModel(
    days: spaceDocument['weekdays'] == null
        ? null
        : Days(
            monday: Hours(
              from: spaceDocument['weekdays']['monday']['from'],
              to: spaceDocument['weekdays']['monday']['to'],
            ),
            tuesday: Hours(
              from: spaceDocument['weekdays']['tuesday']['from'],
              to: spaceDocument['weekdays']['tuesday']['to'],
            ),
            wednesday: Hours(
              from: spaceDocument['weekdays']['wednesday']['from'],
              to: spaceDocument['weekdays']['wednesday']['to'],
            ),
            thursday: Hours(
              from: spaceDocument['weekdays']['thursday']['from'],
              to: spaceDocument['weekdays']['thursday']['to'],
            ),
            friday: Hours(
              from: spaceDocument['weekdays']['friday']['from'],
              to: spaceDocument['weekdays']['friday']['to'],
            ),
            saturday: Hours(
              from: spaceDocument['weekdays']['saturday']['from'],
              to: spaceDocument['weekdays']['saturday']['to'],
            ),
            sunday: Hours(
              from: spaceDocument['weekdays']['sunday']['from'],
              to: spaceDocument['weekdays']['sunday']['to'],
            ),
          ),
    videosUrl: List<String>.from(spaceDocument['videos'] ?? []),
    isFavorited: isFavorited,
    spaceId: spaceDocument['space_id'] ?? '',
    userId: spaceDocument['user_id'] ?? '',
    titulo: spaceDocument['titulo'] ?? '',
    cep: spaceDocument['cep'] ?? '',
    logradouro: spaceDocument['logradouro'] ?? '',
    numero: spaceDocument['numero'] ?? '',
    bairro: spaceDocument['bairro'] ?? '',
    cidade: spaceDocument['cidade'] ?? '',
    selectedTypes: selectedTypes,
    selectedServices: selectedServices,
    averageRating: averageRating,
    numComments: numComments,
    locadorName: spaceDocument['locador_name'] ?? '',
    descricao: spaceDocument['descricao'] ?? '',
    city: spaceDocument['city'] ?? '',
    imagesUrl: imagesUrl,
    latitude: spaceDocument['latitude'] ?? 0.0,
    longitude: spaceDocument['longitude'] ?? 0.0,
    locadorAvatarUrl: spaceDocument['locadorAvatarUrl'] ?? '',
    startTime: spaceDocument['startTime'] ?? '',
    endTime: spaceDocument['endTime'] ?? '',
    preco: spaceDocument['preco'] ?? '',
    cnpjEmpresaLocadora: spaceDocument['cnpj_empresa_locadora'] ?? '',
    estado: spaceDocument['estado'] ?? '',
    locadorCpf: spaceDocument['locador_cpf'] ?? '',
    nomeEmpresaLocadora: spaceDocument['nome_empresa_locadora'] ?? '',
    locadorAssinatura: spaceDocument['locador_assinatura'] ?? '',
    numLikes: spaceDocument['num_likes'] ?? 0,
  );
}

Future<String> getAverageRating(String spaceId) async {
  final spaceDocument = await FirebaseFirestore.instance
      .collection('spaces')
      .where('space_id', isEqualTo: spaceId)
      .get();

  if (spaceDocument.docs.isNotEmpty) {
    String averageRatingValue = spaceDocument.docs.first['average_rating'];
    return averageRatingValue;
  }

  // Trate o caso em que nenhum espaço foi encontrado.
  throw Exception("Espaço não encontrado");
}

Future<String> getNumComments(String spaceId) async {
  final spaceDocument = await FirebaseFirestore.instance
      .collection('spaces')
      .where('space_id', isEqualTo: spaceId)
      .get();

  if (spaceDocument.docs.isNotEmpty) {
    String numComments = spaceDocument.docs.first['num_comments'];
    return numComments;
  }

  // Trate o caso em que nenhum espaço foi encontrado.
  throw Exception("Espaço não encontrado");
}

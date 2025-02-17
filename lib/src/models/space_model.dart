import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festou/src/services/avaliacoes_service.dart';

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
  final List<String> imagesUrl;
  final List<String> videosUrl;

  final double latitude;
  final double longitude;

  final String locadorAvatarUrl;
  final String preco;

  final String cnpjEmpresaLocadora;
  final String estado;
  final String locadorCpf;
  final String nomeEmpresaLocadora;
  final String locadorAssinatura;
  final int numLikes;
  final Days days;

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
    required this.imagesUrl,
    required this.latitude,
    required this.longitude,
    required this.locadorAvatarUrl,
    required this.preco,
    required this.cnpjEmpresaLocadora,
    required this.estado,
    required this.locadorCpf,
    required this.nomeEmpresaLocadora,
    required this.locadorAssinatura,
    required this.videosUrl,
  });

  factory SpaceModel.fromMap(Map<String, dynamic> map) {
    return SpaceModel(
      isFavorited: map['isFavorited'] ?? false,
      spaceId: map['space_id'] ?? '',
      userId: map['user_id'] ?? '',
      titulo: map['titulo'] ?? '',
      cep: map['cep'] ?? '',
      logradouro: map['logradouro'] ?? '',
      numero: map['numero'] ?? '',
      bairro: map['bairro'] ?? '',
      cidade: map['cidade'] ?? '',
      selectedTypes: List<String>.from(map['selectedTypes'] ?? []),
      selectedServices: List<String>.from(map['selectedServices'] ?? []),
      averageRating: map['average_rating']?.toString() ?? '0',
      numComments: map['num_comments']?.toString() ?? '0',
      locadorName: map['locador_name'] ?? '',
      descricao: map['descricao'] ?? '',
      imagesUrl: List<String>.from(map['images_url'] ?? []),
      videosUrl: List<String>.from(map['videos'] ?? []),
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      locadorAvatarUrl: map['locadorAvatarUrl'] ?? '',
      preco: map['preco'] ?? '',
      cnpjEmpresaLocadora: map['cnpj_empresa_locadora'] ?? '',
      estado: map['estado'] ?? '',
      locadorCpf: map['locador_cpf'] ?? '',
      nomeEmpresaLocadora: map['nome_empresa_locadora'] ?? '',
      locadorAssinatura: map['locador_assinatura'] ?? '',
      numLikes: map['num_likes'] ?? 0,
      days: Days(
        monday: map['weekdays']?['monday'] != null
            ? Hours(
                from: map['weekdays']['monday']['from'] ?? '',
                to: map['weekdays']['monday']['to'] ?? '',
              )
            : null,
        tuesday: map['weekdays']?['tuesday'] != null
            ? Hours(
                from: map['weekdays']['tuesday']['from'] ?? '',
                to: map['weekdays']['tuesday']['to'] ?? '',
              )
            : null,
        wednesday: map['weekdays']?['wednesday'] != null
            ? Hours(
                from: map['weekdays']['wednesday']['from'] ?? '',
                to: map['weekdays']['wednesday']['to'] ?? '',
              )
            : null,
        thursday: map['weekdays']?['thursday'] != null
            ? Hours(
                from: map['weekdays']['thursday']['from'] ?? '',
                to: map['weekdays']['thursday']['to'] ?? '',
              )
            : null,
        friday: map['weekdays']?['friday'] != null
            ? Hours(
                from: map['weekdays']['friday']['from'] ?? '',
                to: map['weekdays']['friday']['to'] ?? '',
              )
            : null,
        saturday: map['weekdays']?['saturday'] != null
            ? Hours(
                from: map['weekdays']['saturday']['from'] ?? '',
                to: map['weekdays']['saturday']['to'] ?? '',
              )
            : null,
        sunday: map['weekdays']?['sunday'] != null
            ? Hours(
                from: map['weekdays']['sunday']['from'] ?? '',
                to: map['weekdays']['sunday']['to'] ?? '',
              )
            : null,
      ),
    );
  }
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
    days: Days(
      monday: spaceDocument['weekdays']['monday'] != null
          ? Hours(
              from: spaceDocument['weekdays']['monday']['from'] ?? '',
              to: spaceDocument['weekdays']['monday']['to'] ?? '',
            )
          : null,
      tuesday: spaceDocument['weekdays']['tuesday'] != null
          ? Hours(
              from: spaceDocument['weekdays']['tuesday']['from'] ?? '',
              to: spaceDocument['weekdays']['tuesday']['to'] ?? '',
            )
          : null,
      wednesday: spaceDocument['weekdays']['wednesday'] != null
          ? Hours(
              from: spaceDocument['weekdays']['wednesday']['from'] ?? '',
              to: spaceDocument['weekdays']['wednesday']['to'] ?? '',
            )
          : null,
      thursday: spaceDocument['weekdays']['thursday'] != null
          ? Hours(
              from: spaceDocument['weekdays']['thursday']['from'] ?? '',
              to: spaceDocument['weekdays']['thursday']['to'] ?? '',
            )
          : null,
      friday: spaceDocument['weekdays']['friday'] != null
          ? Hours(
              from: spaceDocument['weekdays']['friday']['from'] ?? '',
              to: spaceDocument['weekdays']['friday']['to'] ?? '',
            )
          : null,
      saturday: spaceDocument['weekdays']['saturday'] != null
          ? Hours(
              from: spaceDocument['weekdays']['saturday']['from'] ?? '',
              to: spaceDocument['weekdays']['saturday']['to'] ?? '',
            )
          : null,
      sunday: spaceDocument['weekdays']['sunday'] != null
          ? Hours(
              from: spaceDocument['weekdays']['sunday']['from'] ?? '',
              to: spaceDocument['weekdays']['sunday']['to'] ?? '',
            )
          : null,
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
    imagesUrl: imagesUrl,
    latitude: spaceDocument['latitude'] ?? 0.0,
    longitude: spaceDocument['longitude'] ?? 0.0,
    locadorAvatarUrl: spaceDocument['locadorAvatarUrl'] ?? '',
    preco: spaceDocument['preco'] ?? '',
    cnpjEmpresaLocadora: spaceDocument['cnpj_empresa_locadora'] ?? '',
    estado: spaceDocument['estado'] ?? '',
    locadorCpf: spaceDocument['locador_cpf'] ?? '',
    nomeEmpresaLocadora: spaceDocument['nome_empresa_locadora'] ?? '',
    locadorAssinatura: spaceDocument['locador_assinatura'] ?? '',
    numLikes: spaceDocument['num_likes'] ?? 0,
  );
}

/**
 * 
 * feedbacks = await feedbackService.getFeedbacksOrdered(widget.spaceId);
    feedbacks!.removeWhere((f) => f.deletedAt != null);
    if (feedbacks!.isNotEmpty) {
      int totalRating = 0;
      for (final feedback in feedbacks!) {
        totalRating += feedback.rating;
      }
      averageRating = totalRating / feedbacks!.length;
    }
 */
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
    days: Days(
      monday: spaceDocument['weekdays']['monday'] == null
          ? null
          : Hours(
              from: spaceDocument['weekdays']['monday']['from'],
              to: spaceDocument['weekdays']['monday']['to'],
            ),
      tuesday: spaceDocument['weekdays']['tuesday'] == null
          ? null
          : Hours(
              from: spaceDocument['weekdays']['tuesday']['from'],
              to: spaceDocument['weekdays']['tuesday']['to'],
            ),
      wednesday: spaceDocument['weekdays']['wednesday'] == null
          ? null
          : Hours(
              from: spaceDocument['weekdays']['wednesday']['from'],
              to: spaceDocument['weekdays']['wednesday']['to'],
            ),
      thursday: spaceDocument['weekdays']['thursday'] == null
          ? null
          : Hours(
              from: spaceDocument['weekdays']['thursday']['from'],
              to: spaceDocument['weekdays']['thursday']['to'],
            ),
      friday: spaceDocument['weekdays']['friday'] == null
          ? null
          : Hours(
              from: spaceDocument['weekdays']['friday']['from'],
              to: spaceDocument['weekdays']['friday']['to'],
            ),
      saturday: spaceDocument['weekdays']['saturday'] == null
          ? null
          : Hours(
              from: spaceDocument['weekdays']['saturday']['from'],
              to: spaceDocument['weekdays']['saturday']['to'],
            ),
      sunday: spaceDocument['weekdays']['sunday'] == null
          ? null
          : Hours(
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
    imagesUrl: imagesUrl,
    latitude: spaceDocument['latitude'] ?? 0.0,
    longitude: spaceDocument['longitude'] ?? 0.0,
    locadorAvatarUrl: spaceDocument['locadorAvatarUrl'] ?? '',
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
  double averageRating = 0;
  final feedbacks = await AvaliacoesService().getFeedbacksOrdered(spaceId);
  feedbacks.removeWhere((f) => f.deletedAt != null);
  if (feedbacks.isNotEmpty) {
    int totalRating = 0;
    for (final feedback in feedbacks) {
      totalRating += feedback.rating;
    }
    averageRating = totalRating / feedbacks.length;
  }
  return averageRating.toStringAsFixed(1);
}

Future<String> getNumComments(String spaceId) async {
  final spaceDocument = await FirebaseFirestore.instance
      .collection('spaces')
      .where('deletedAt', isNull: true)
      .where('space_id', isEqualTo: spaceId)
      .get();

  if (spaceDocument.docs.isNotEmpty) {
    String numComments = spaceDocument.docs.first['num_comments'];
    return numComments;
  }

  // Trate o caso em que nenhum espaço foi encontrado.
  throw Exception("Espaço não encontrado");
}

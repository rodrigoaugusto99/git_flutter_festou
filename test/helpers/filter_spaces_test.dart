import 'package:festou/src/core/fp/either.dart';
import 'package:festou/src/models/space_model.dart';
import 'package:flutter_test/flutter_test.dart';

// Exceção customizada para testes
class FilterException implements Exception {
  final String message;
  FilterException(this.message);
}

// Função auxiliar que implementa a mesma lógica do filterSpaces
// Esta é a função que vamos testar isoladamente
Future<Either<FilterException, List<SpaceModel>>> filterSpaces(
  List<SpaceModel> spaces1,
  List<SpaceModel> spaces2,
  List<SpaceModel> spaces3,
) async {
  try {
    if (spaces1.isNotEmpty && spaces2.isEmpty && spaces3.isEmpty) {
      return Success(spaces1);
    } else if (spaces1.isEmpty && spaces2.isNotEmpty && spaces3.isEmpty) {
      return Success(spaces2);
    } else if (spaces1.isEmpty && spaces2.isEmpty && spaces3.isNotEmpty) {
      return Success(spaces3);
    } else if (spaces1.isNotEmpty && spaces2.isNotEmpty && spaces3.isEmpty) {
      final intersection = spaces1
          .where((space1) =>
              spaces2.any((space2) => space1.spaceId == space2.spaceId))
          .toList();
      return Success(intersection);
    } else if (spaces1.isNotEmpty && spaces2.isEmpty && spaces3.isNotEmpty) {
      final intersection = spaces1
          .where((space1) =>
              spaces3.any((space3) => space1.spaceId == space3.spaceId))
          .toList();
      return Success(intersection);
    } else if (spaces1.isEmpty && spaces2.isNotEmpty && spaces3.isNotEmpty) {
      final intersection = spaces2
          .where((space2) =>
              spaces3.any((space3) => space2.spaceId == space3.spaceId))
          .toList();
      return Success(intersection);
    } else if (spaces1.isNotEmpty && spaces2.isNotEmpty && spaces3.isNotEmpty) {
      final intersection1 = spaces1
          .where((space1) =>
              spaces2.any((space2) => space1.spaceId == space2.spaceId))
          .toList();
      final finalIntersection = intersection1
          .where((space1) =>
              spaces3.any((space3) => space1.spaceId == space3.spaceId))
          .toList();
      return Success(finalIntersection);
    } else {
      return Success([]);
    }
  } catch (e) {
    return Failure(FilterException('Erro ao filtrar espaços: $e'));
  }
}

void main() {
  // Helper para criar um SpaceModel simples com um ID específico
  SpaceModel createSpace(String spaceId) {
    return SpaceModel(
      spaceId: spaceId,
      userId: 'user_$spaceId',
      titulo: 'Space $spaceId',
      descricao: 'Description $spaceId',
      selectedServices: [],
      selectedTypes: [],
      imagesUrl: [],
      videosUrl: [],
      preco: '100',
      cep: '12345-000',
      logradouro: 'Rua A',
      numero: '1',
      bairro: 'Bairro A',
      cidade: 'Cidade A',
      estado: 'Estado A',
      latitude: 0.0,
      longitude: 0.0,
      days: Days(
        monday: null,
        tuesday: null,
        wednesday: null,
        thursday: null,
        friday: null,
        saturday: null,
        sunday: null,
      ),
      numComments: '0',
      averageRating: '0',
      numLikes: 0,
      isFavorited: false,
      locadorName: 'Locador $spaceId',
      locadorAvatarUrl: '',
      locadorAssinatura: '',
      locadorCpf: '',
      nomeEmpresaLocadora: '',
      cnpjEmpresaLocadora: '',
    );
  }

  group('filterSpaces - Testes de Filtro de Espaços', () {
    test('Caso 1: Apenas spaces1 não vazio - deve retornar spaces1', () async {
      final spaces1 = [createSpace('1'), createSpace('2')];
      final spaces2 = <SpaceModel>[];
      final spaces3 = <SpaceModel>[];

      final result = await filterSpaces(spaces1, spaces2, spaces3);

      expect(result is Success, true);
      final spaces = (result as Success).value as List<SpaceModel>;
      expect(spaces.length, 2);
      expect(spaces, equals(spaces1));
    });

    test('Caso 2: Apenas spaces2 não vazio - deve retornar spaces2', () async {
      final spaces1 = <SpaceModel>[];
      final spaces2 = [createSpace('2')];
      final spaces3 = <SpaceModel>[];

      final result = await filterSpaces(spaces1, spaces2, spaces3);

      expect(result is Success, true);
      final spaces = (result as Success).value as List<SpaceModel>;
      expect(spaces.length, 1);
      expect(spaces, equals(spaces2));
    });

    test('Caso 3: Apenas spaces3 não vazio - deve retornar spaces3', () async {
      final spaces1 = <SpaceModel>[];
      final spaces2 = <SpaceModel>[];
      final spaces3 = [createSpace('3')];

      final result = await filterSpaces(spaces1, spaces2, spaces3);

      expect(result is Success, true);
      final spaces = (result as Success).value as List<SpaceModel>;
      expect(spaces.length, 1);
      expect(spaces, equals(spaces3));
    });

    test('Caso 4: Interseção spaces1 e spaces2 - deve retornar comuns',
        () async {
      final space1 = createSpace('1');
      final space2 = createSpace('2');
      final space3 = createSpace('3');

      final spaces1 = [space1, space2];
      final spaces2 = [space2, space3];
      final spaces3 = <SpaceModel>[];

      final result = await filterSpaces(spaces1, spaces2, spaces3);

      expect(result is Success, true);
      final spaces = (result as Success).value as List<SpaceModel>;
      expect(spaces.length, 1);
      expect(spaces.first.spaceId, '2');
    });

    test('Caso 5: Interseção spaces1 e spaces3 - deve retornar comuns',
        () async {
      final space1 = createSpace('1');
      final space2 = createSpace('2');
      final space3 = createSpace('3');

      final spaces1 = [space1, space3];
      final spaces2 = <SpaceModel>[];
      final spaces3 = [space2, space3];

      final result = await filterSpaces(spaces1, spaces2, spaces3);

      expect(result is Success, true);
      final spaces = (result as Success).value as List<SpaceModel>;
      expect(spaces.length, 1);
      expect(spaces.first.spaceId, '3');
    });

    test('Caso 6: Interseção spaces2 e spaces3 - deve retornar comuns',
        () async {
      final space1 = createSpace('1');
      final space2 = createSpace('2');
      final space3 = createSpace('3');

      final spaces1 = <SpaceModel>[];
      final spaces2 = [space1, space2];
      final spaces3 = [space2, space3];

      final result = await filterSpaces(spaces1, spaces2, spaces3);

      expect(result is Success, true);
      final spaces = (result as Success).value as List<SpaceModel>;
      expect(spaces.length, 1);
      expect(spaces.first.spaceId, '2');
    });

    test('Caso 7: Interseção das três listas - deve retornar comuns a todas',
        () async {
      final space1 = createSpace('1');
      final space2 = createSpace('2');
      final space3 = createSpace('3');

      final spaces1 = [space1, space2, space3];
      final spaces2 = [space2, space3];
      final spaces3 = [space2];

      final result = await filterSpaces(spaces1, spaces2, spaces3);

      expect(result is Success, true);
      final spaces = (result as Success).value as List<SpaceModel>;
      expect(spaces.length, 1);
      expect(spaces.first.spaceId, '2');
    });

    test('Caso 8: Todas as listas vazias - deve retornar lista vazia',
        () async {
      final spaces1 = <SpaceModel>[];
      final spaces2 = <SpaceModel>[];
      final spaces3 = <SpaceModel>[];

      final result = await filterSpaces(spaces1, spaces2, spaces3);

      expect(result is Success, true);
      final spaces = (result as Success).value as List<SpaceModel>;
      expect(spaces.isEmpty, true);
    });

    test('Caso 9: Sem interseção - deve retornar lista vazia', () async {
      final spaces1 = [createSpace('1')];
      final spaces2 = [createSpace('2')];
      final spaces3 = [createSpace('3')];

      final result = await filterSpaces(spaces1, spaces2, spaces3);

      expect(result is Success, true);
      final spaces = (result as Success).value as List<SpaceModel>;
      expect(spaces.isEmpty, true);
    });

    test('Caso 10: Múltiplos elementos na interseção', () async {
      final space1 = createSpace('1');
      final space2 = createSpace('2');
      final space3 = createSpace('3');
      final space4 = createSpace('4');

      final spaces1 = [space1, space2, space3];
      final spaces2 = [space2, space3, space4];
      final spaces3 = <SpaceModel>[];

      final result = await filterSpaces(spaces1, spaces2, spaces3);

      expect(result is Success, true);
      final spaces = (result as Success).value as List<SpaceModel>;
      expect(spaces.length, 2);
      expect(spaces.map((s) => s.spaceId).toList(), containsAll(['2', '3']));
    });
  });
}

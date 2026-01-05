import 'package:festou/src/helpers/helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('extrairNumerosComoInteiro', () {
    test('deve extrair números de string com formato de moeda brasileira', () {
      // Arrange
      const input = 'R\$ 2.229,00';

      // Act
      final result = extrairNumerosComoInteiro(input);

      // Assert
      expect(result, 222900);
    });

    test('deve extrair números de string simples', () {
      // Arrange
      const input = '12345';

      // Act
      final result = extrairNumerosComoInteiro(input);

      // Assert
      expect(result, 12345);
    });

    test('deve extrair números de string com caracteres especiais', () {
      // Arrange
      const input = 'R\$ 1.000.000,99';

      // Act
      final result = extrairNumerosComoInteiro(input);

      // Assert
      expect(result, 100000099);
    });

    test('deve retornar 0 para string vazia', () {
      // Arrange
      const input = '';

      // Act
      final result = extrairNumerosComoInteiro(input);

      // Assert
      expect(result, 0);
    });

    test('deve retornar 0 para string sem números', () {
      // Arrange
      const input = 'ABC';

      // Act
      final result = extrairNumerosComoInteiro(input);

      // Assert
      expect(result, 0);
    });
  });

  group('formatarCentavosParaReais', () {
    test('deve formatar centavos para formato de moeda brasileira', () {
      // Arrange
      const centavos = 123456;

      // Act
      final result = formatarCentavosParaReais(centavos);

      // Assert
      expect(result, 'R\$ 1.234,56');
    });

    test('deve formatar valor zero corretamente', () {
      // Arrange
      const centavos = 0;

      // Act
      final result = formatarCentavosParaReais(centavos);

      // Assert
      expect(result, 'R\$ 0,00');
    });

    test('deve formatar valor menor que 1 real corretamente', () {
      // Arrange
      const centavos = 99;

      // Act
      final result = formatarCentavosParaReais(centavos);

      // Assert
      expect(result, 'R\$ 0,99');
    });

    test('deve formatar valor grande corretamente', () {
      // Arrange
      const centavos = 100000000; // 1 milhão de reais

      // Act
      final result = formatarCentavosParaReais(centavos);

      // Assert
      expect(result, 'R\$ 1.000.000,00');
    });
  });

  group('transformarParaFormatoDecimal', () {
    test('deve transformar moeda brasileira para formato decimal', () {
      // Arrange
      const input = 'R\$ 2.229,00';

      // Act
      final result = transformarParaFormatoDecimal(input);

      // Assert
      expect(result, 2229.00);
    });

    test('deve transformar valor sem símbolo de moeda', () {
      // Arrange
      const input = '1.500,50';

      // Act
      final result = transformarParaFormatoDecimal(input);

      // Assert
      expect(result, 1500.50);
    });

    test('deve transformar valor com apenas vírgula', () {
      // Arrange
      const input = '123,45';

      // Act
      final result = transformarParaFormatoDecimal(input);

      // Assert
      expect(result, 123.45);
    });

    test('deve transformar valor inteiro', () {
      // Arrange
      const input = 'R\$ 1.000,00';

      // Act
      final result = transformarParaFormatoDecimal(input);

      // Assert
      expect(result, 1000.00);
    });

    test('deve retornar null para string inválida', () {
      // Arrange
      const input = 'ABC';

      // Act
      final result = transformarParaFormatoDecimal(input);

      // Assert
      expect(result, null);
    });

    test('deve retornar null para string vazia', () {
      // Arrange
      const input = '';

      // Act
      final result = transformarParaFormatoDecimal(input);

      // Assert
      expect(result, null);
    });
  });

  group('trocarPontoPorVirgula', () {
    test('deve trocar ponto por vírgula', () {
      // Arrange
      const input = '123.45';

      // Act
      final result = trocarPontoPorVirgula(input);

      // Assert
      expect(result, '123,45');
    });

    test('deve adicionar ,00 quando não há vírgula', () {
      // Arrange
      const input = '123';

      // Act
      final result = trocarPontoPorVirgula(input);

      // Assert
      expect(result, '123,00');
    });

    test('deve adicionar 0 quando há apenas um dígito após vírgula', () {
      // Arrange
      const input = '123.5';

      // Act
      final result = trocarPontoPorVirgula(input);

      // Assert
      expect(result, '123,50');
    });

    test('deve manter valor quando já está no formato correto', () {
      // Arrange
      const input = '123,45';

      // Act
      final result = trocarPontoPorVirgula(input);

      // Assert
      expect(result, '123,45');
    });

    test('deve tratar valor zero corretamente', () {
      // Arrange
      const input = '0';

      // Act
      final result = trocarPontoPorVirgula(input);

      // Assert
      expect(result, '0,00');
    });

    test('deve tratar valor decimal zero corretamente', () {
      // Arrange
      const input = '0.00';

      // Act
      final result = trocarPontoPorVirgula(input);

      // Assert
      expect(result, '0,00');
    });

    test('deve tratar valor grande corretamente', () {
      // Arrange
      const input = '1000000.99';

      // Act
      final result = trocarPontoPorVirgula(input);

      // Assert
      expect(result, '1000000,99');
    });
  });

  group('transformarParaFormatoDecimal2', () {
    test('deve transformar moeda brasileira para string decimal', () {
      // Arrange
      const input = 'R\$ 2.229,00';

      // Act
      final result = transformarParaFormatoDecimal2(input);

      // Assert
      expect(result, '2229.00');
    });

    test('deve transformar valor sem símbolo', () {
      // Arrange
      const input = '1.500,50';

      // Act
      final result = transformarParaFormatoDecimal2(input);

      // Assert
      expect(result, '1500.50');
    });

    test('deve retornar string vazia para entrada vazia', () {
      // Arrange
      const input = '';

      // Act
      final result = transformarParaFormatoDecimal2(input);

      // Assert
      expect(result, '');
    });

    test('deve remover todos os caracteres não numéricos exceto vírgula', () {
      // Arrange
      const input = 'ABC R\$ 123.456,78 XYZ';

      // Act
      final result = transformarParaFormatoDecimal2(input);

      // Assert
      expect(result, '123456.78');
    });
  });
}

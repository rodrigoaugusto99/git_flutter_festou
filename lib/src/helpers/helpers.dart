import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color getColor(double averageRating) {
  if (averageRating >= 4) {
    return Colors.green; // Ícone verde para rating maior ou igual a 4
  } else if (averageRating >= 2 && averageRating < 4) {
    return Colors.orange; // Ícone laranja para rating entre 2 e 4 (exclusive)
  } else {
    return Colors.red; // Ícone vermelho para rating abaixo de 2
  }
}

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

// "R\$ 2.229,00"; =222900
int extrairNumerosComoInteiro(String texto) {
  // Remove todos os caracteres não numéricos da string
  String apenasNumeros = texto.replaceAll(RegExp(r'[^0-9]'), '');

  // Converte a string resultante em um inteiro
  return int.tryParse(apenasNumeros) ?? 0;
}

//123456 -"R$ 1.234,56"
String formatarCentavosParaReais(int centavos) {
  double reais = centavos / 100.0;
  NumberFormat formatoMoeda = NumberFormat.simpleCurrency(locale: 'pt_BR');
  return formatoMoeda.format(reais);
}

//"R\$ 2.229,00" -"2229.00"
double? transformarParaFormatoDecimal(String valor) {
  // Remove o símbolo de moeda, pontos e espaços
  String semFormatacao = valor.replaceAll(RegExp(r'[^\d,]'), '');

  // Substitui a vírgula por ponto para o formato decimal
  String formatoDecimal = semFormatacao.replaceAll(',', '.');

  return double.tryParse(formatoDecimal);
}

String transformarParaFormatoDecimal2(String valor) {
  // Remove o símbolo de moeda, pontos e espaços
  String semFormatacao = valor.replaceAll(RegExp(r'[^\d,]'), '');

  // Substitui a vírgula por ponto para o formato decimal
  String formatoDecimal = semFormatacao.replaceAll(',', '.');

  return formatoDecimal;
}

String trocarPontoPorVirgula(String valor) {
  // Substitui o ponto por vírgula
  String formatado = valor.replaceAll('.', ',');

  // Verifica se já existe uma vírgula no final
  if (!formatado.contains(',')) {
    formatado += ',00'; // Adiciona a vírgula e os dois zeros
  } else {
    // Garante que há dois dígitos após a vírgula
    List<String> partes = formatado.split(',');
    if (partes.length == 2 && partes[1].length == 1) {
      formatado += '0'; // Adiciona um zero se só houver um dígito
    } else if (partes.length == 1) {
      formatado += '00'; // Adiciona dois zeros se não houver fração
    }
  }

  return formatado;
}

Widget decContainer({
  double? radius,
  double? height,
  double? width,
  double? leftPadding,
  double? topPadding,
  double? rightPadding,
  double? bottomPadding,
  double? borderWidth,
  Color? color,
  Color? foregroundColor,
  Color? borderColor,
  double? allPadding,
  Widget? child,
  Function()? onTap,
  Gradient? gradient,
  BoxShadow? boxShadow,
  Alignment? align,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: align,
      clipBehavior: Clip.antiAlias,
      foregroundDecoration: BoxDecoration(color: foregroundColor),
      padding: EdgeInsets.only(
        left: leftPadding ?? allPadding ?? 0,
        top: topPadding ?? allPadding ?? 0,
        right: rightPadding ?? allPadding ?? 0,
        bottom: bottomPadding ?? allPadding ?? 0,
      ),
      height: height,
      width: width,
      decoration: BoxDecoration(
        boxShadow: boxShadow != null ? [boxShadow] : null,
        gradient: gradient,
        color: color,
        border: borderWidth != null && borderColor != null
            ? Border.all(
                width: borderWidth,
                color: borderColor,
              )
            : null,
        borderRadius: radius == null ? null : BorderRadius.circular(radius),
      ),
      child: child,
    ),
  );
}

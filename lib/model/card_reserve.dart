import 'package:intl/intl.dart';

class Reserva {
  DateTime diaDoMes;
  String horaDeAbertura;
  String horaDeFechamento;

  Reserva({
    required this.diaDoMes,
    required this.horaDeAbertura,
    required this.horaDeFechamento,
  });

  @override
  String toString() {
    String formattedDate = DateFormat('dd/MM/yyyy').format(diaDoMes);
    return 'Dia $formattedDate, das $horaDeAbertura às $horaDeFechamento';
  }
}

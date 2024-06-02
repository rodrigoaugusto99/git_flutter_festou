import 'package:git_flutter_festou/src/models/cupom_model.dart';
import 'package:git_flutter_festou/src/models/space_model.dart';

class SummaryData {
  DateTime? dataAtual;
  DateTime selectedDate;
  DateTime? selectedFinalDate;
  SpaceModel spaceModel;
  int checkInTime;
  int checkOutTime;
  String html;
  String? totalHours;
  String? valorTotalDasHoras;
  String? valorDaTaxaConcierge;
  String? valorTotalAPagar;
  String? valorDaMultaPorHoraExtrapolada;
  String? nomeDoCliente;
  String? cpfDoCliente;
  String? nomeDoLocador;
  String? cpfDoLocador;

  SummaryData({
    required this.dataAtual,
    required this.selectedDate,
    required this.selectedFinalDate,
    required this.spaceModel,
    required this.checkInTime,
    required this.checkOutTime,
    required this.html,
    required this.totalHours,
    required this.valorTotalDasHoras,
    required this.valorDaTaxaConcierge,
    required this.valorTotalAPagar,
    required this.valorDaMultaPorHoraExtrapolada,
    required this.nomeDoCliente,
    required this.cpfDoCliente,
    required this.nomeDoLocador,
    required this.cpfDoLocador,
  });
}

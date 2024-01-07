class ReservationModel {
  final String userId;
  final String spaceId;
  final String range;
  final String date;
  final String status;

  ReservationModel({
    required this.spaceId,
    required this.userId,
    required this.range,
    required this.date,
    required this.status,
  });
}

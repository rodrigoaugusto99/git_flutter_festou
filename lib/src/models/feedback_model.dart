class FeedbackModel {
  final int rating;
  final String content;
  final String userId;
  final String spaceId;
  final String userName;
  final String date;
  final String avatar;

  FeedbackModel({
    required this.rating,
    required this.content,
    required this.spaceId,
    required this.userId,
    required this.userName,
    required this.date,
    required this.avatar,
  });
}

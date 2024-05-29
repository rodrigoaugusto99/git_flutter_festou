class FeedbackModel {
  final String id;
  final int rating;
  final String content;
  final String userId;
  final String spaceId;
  final String userName;
  final String date;
  final String avatar;
  final List<String> likes;
  final List<String> dislikes;

  FeedbackModel({
    required this.id,
    required this.rating,
    required this.content,
    required this.spaceId,
    required this.userId,
    required this.userName,
    required this.date,
    required this.avatar,
    required this.likes,
    required this.dislikes,
  });
}

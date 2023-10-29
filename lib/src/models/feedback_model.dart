class FeedbackModel {
  final int rating;
  final String content;
  final String userId;
  final String spaceId;
  final String userName;

  final String date;

  FeedbackModel({
    required this.rating,
    required this.content,
    required this.spaceId,
    required this.userId,
    required this.userName,
    required this.date,
  });

  // Converte um objeto FeedbackModel em um Map
  /*Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'content': content,
      'user_id': userId,
      'spaceId': spaceId,
    };
  }

  // Cria um objeto FeedbackModel a partir de um Map
  static FeedbackModel fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      rating: map['rating'] ?? 0,
      content: map['content'] ?? '',
      userId: map['user_id'] ?? '',
      spaceId: map['space_id'] ?? '',
    );
  }*/
}

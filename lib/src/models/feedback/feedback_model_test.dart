class FeedbackModel {
  final int rating;
  final String content;

  FeedbackModel({
    required this.rating,
    required this.content,
  });

  // Converte um objeto FeedbackModel em um Map
  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'content': content,
    };
  }

  // Cria um objeto FeedbackModel a partir de um Map
  static FeedbackModel fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      rating: map['rating'] ??
          0, // Defina um valor padrão ou trate valores nulos conforme necessário
      content: map['content'] ?? '',
    );
  }
}

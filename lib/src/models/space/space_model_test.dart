class SpaceModelTest {
  final String name = 'rodrigo';
  final String email = 'email';
  final String cep = '22221000';
  final String endereco = 'endereco';
  final String numero = '123';
  final String bairro = 'catete';
  final String cidade = 'rio de janeiro';
  final List<String> selectedTypes = ['Casamento', 'Festa Infantil'];
  final List<String> selectedServices = ['Ar-Condicionado', 'Wi-fi', 'Cantina'];
  final List<String> availableDays = ['Seg', 'Ter', 'Sex', 'Sab'];
  final List<FeedbackModel> feedbackModel = [
    FeedbackModel(
      rating: 1,
      content: 'ORRIVEO',
    ),
    FeedbackModel(
      rating: 3,
      content: 'bueno',
    ),
    FeedbackModel(
      rating: 2,
      content: 'Bem fraquinho',
    ),
    FeedbackModel(
      rating: 4,
      content: 'Gostei bastante, só não gostei disso disso e daquilo',
    ),
    FeedbackModel(
      rating: 5,
      content: 'rodrigo',
    ),
  ];
}

class FeedbackModel {
  final int rating;
  final String content;

  FeedbackModel({
    required this.rating,
    required this.content,
  });
}

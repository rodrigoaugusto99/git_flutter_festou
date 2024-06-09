class PostModel {
  String? id;
  String title;
  String description;
  List<String> imagens;

  PostModel({
    this.id,
    required this.title,
    required this.description,
    required this.imagens,
  });
}

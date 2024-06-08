class PostModel {
  String? id;
  String title;
  String description;
  List<String> imagens;
  String coverPhoto;
  PostModel({
    this.id,
    required this.title,
    required this.description,
    required this.imagens,
    required this.coverPhoto,
  });
}

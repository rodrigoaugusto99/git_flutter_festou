import 'package:git_flutter_festou/src/models/user_model.dart';

class UserWithImages {
  final UserModel user;
  final List<String> imageUrls;
  final List<String> avatar;
  final String doc1Url;
  final String doc2Url;
  final String avatarUrl;

  UserWithImages(
    this.user,
    this.imageUrls,
    this.avatar,
    this.doc1Url,
    this.doc2Url,
    this.avatarUrl,
  );
}

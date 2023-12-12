import 'package:git_flutter_festou/src/models/user_model.dart';

class UserWithImages {
  final UserModel user;
  final List<String> imageUrls;
  final List<String> avatar;

  UserWithImages(
    this.user,
    this.imageUrls,
    this.avatar,
  );
}

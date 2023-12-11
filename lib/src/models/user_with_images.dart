import 'package:git_flutter_festou/src/models/user_model.dart';

class UserWithImages {
  final UserModel user;
  final List<String> imageUrls;

  UserWithImages(this.user, this.imageUrls);
}

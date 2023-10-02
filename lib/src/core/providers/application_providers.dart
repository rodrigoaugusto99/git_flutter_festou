import 'package:git_flutter_festou/src/repositories/user/user_repository.dart';
import 'package:git_flutter_festou/src/repositories/user/user_repository_impl.dart';
import 'package:git_flutter_festou/src/services/user_login/user_login_service.dart';
import 'package:git_flutter_festou/src/services/user_login/user_login_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'application_providers.g.dart';

@Riverpod(keepAlive: true)
UserRepository userRepository(UserRepositoryRef ref) => UserRepositoryImpl();

@Riverpod(keepAlive: true)
UserLoginService userLoginService(UserLoginServiceRef ref) =>
    UserLoginServiceImpl(userRepository: ref.read(userRepositoryProvider));

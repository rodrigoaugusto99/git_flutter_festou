import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/festou_nav_global_key.dart';
import 'package:git_flutter_festou/src/repositories/feedback/feedback_firestore_repository.dart';
import 'package:git_flutter_festou/src/repositories/feedback/feedback_firestore_repository_impl.dart';
import 'package:git_flutter_festou/src/repositories/space/space_firestore_repository.dart';
import 'package:git_flutter_festou/src/repositories/space/space_firestore_repository_impl.dart';
import 'package:git_flutter_festou/src/repositories/user/user_auth_repository.dart';
import 'package:git_flutter_festou/src/repositories/user/user_auth_repository_impl.dart';
import 'package:git_flutter_festou/src/repositories/user/user_firestore_repository.dart';
import 'package:git_flutter_festou/src/repositories/user/user_firestore_repository_impl.dart';
import 'package:git_flutter_festou/src/services/user_login/user_login_service.dart';
import 'package:git_flutter_festou/src/services/user_login/user_login_service_impl.dart';
import 'package:git_flutter_festou/src/services/user_register/user_register_service.dart';
import 'package:git_flutter_festou/src/services/user_register/user_register_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'application_providers.g.dart';

@Riverpod(keepAlive: true)
UserAuthRepository userAuthRepository(UserAuthRepositoryRef ref) =>
    UserAuthRepositoryImpl();

//firestore
@Riverpod(keepAlive: true)
UserFirestoreRepository userFirestoreRepository(
        UserFirestoreRepositoryRef ref) =>
    UserFirestoreRepositoryImpl();

@Riverpod(keepAlive: true)
UserLoginService userLoginService(UserLoginServiceRef ref) =>
    UserLoginServiceImpl(
        userAuthRepository: ref.read(userAuthRepositoryProvider));

@Riverpod(keepAlive: true)
UserRegisterService userRegisterService(UserRegisterServiceRef ref) =>
    UserRegisterServiceImpl(
        userAuthRepository: ref.watch(userAuthRepositoryProvider),
        userLoginService: ref.watch(userLoginServiceProvider),
        userFirestoreRepository: ref.watch(userFirestoreRepositoryProvider));

//firestore
@Riverpod(keepAlive: true)
SpaceFirestoreRepository spaceFirestoreRepository(
        SpaceFirestoreRepositoryRef ref) =>
    SpaceFirestoreRepositoryImpl();

@Riverpod(keepAlive: true)
FeedbackFirestoreRepository feedbackFirestoreRepository(
        FeedbackFirestoreRepositoryRef ref) =>
    FeedbackFirestoreRepositoryImpl();

@riverpod
Future<void> logout(LogoutRef ref) async {
  FirebaseAuth.instance.signOut();

  Navigator.of(FestouNavGlobalKey.instance.navKey.currentContext!)
      .pushNamedAndRemoveUntil('/login', (route) => false);
}

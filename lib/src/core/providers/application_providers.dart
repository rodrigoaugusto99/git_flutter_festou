import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/core/ui/festou_nav_global_key.dart';
import 'package:festou/src/repositories/feedback/feedback_firestore_repository.dart';
import 'package:festou/src/repositories/feedback/feedback_firestore_repository_impl.dart';
import 'package:festou/src/repositories/images/images_storage_repository.dart';
import 'package:festou/src/repositories/images/images_storage_repository_impl.dart';
import 'package:festou/src/repositories/space/space_firestore_repository.dart';
import 'package:festou/src/repositories/space/space_firestore_repository_impl.dart';
import 'package:festou/src/repositories/user/user_auth_repository.dart';
import 'package:festou/src/repositories/user/user_auth_repository_impl.dart';
import 'package:festou/src/repositories/user/user_firestore_repository.dart';
import 'package:festou/src/repositories/user/user_firestore_repository_impl.dart';
import 'package:festou/src/services/user_login/user_login_service.dart';
import 'package:festou/src/services/user_login/user_login_service_impl.dart';
import 'package:festou/src/services/user_register/user_register_service.dart';
import 'package:festou/src/services/user_register/user_register_service_impl.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'application_providers.g.dart';

@Riverpod(keepAlive: true)
UserAuthRepository userAuthRepository(UserAuthRepositoryRef ref) =>
    UserAuthRepositoryImpl();

//firestore
@Riverpod(keepAlive: true)
UserFirestoreRepository userFirestoreRepository(
        UserFirestoreRepositoryRef ref) =>
    UserFirestoreRepositoryImpl(
        imagesStorageRepository: ref.watch(imagesStorageRepositoryProvider));

@Riverpod(keepAlive: true)
UserLoginService userLoginService(UserLoginServiceRef ref) =>
    UserLoginServiceImpl(
        userAuthRepository: ref.read(userAuthRepositoryProvider));

@Riverpod(keepAlive: true)
SpaceFirestoreRepository spaceFirestoreRepository(
        SpaceFirestoreRepositoryRef ref) =>
    SpaceFirestoreRepositoryImpl(
      imagesStorageRepository: ref.watch(imagesStorageRepositoryProvider),
      feedbackFirestoreRepository:
          ref.watch(feedbackFirestoreRepositoryProvider),
    );

@Riverpod(keepAlive: true)
ImagesStorageRepository imagesStorageRepository(
        ImagesStorageRepositoryRef ref) =>
    ImagesStorageRepositoryImpl();

@Riverpod(keepAlive: true)
UserRegisterService userRegisterService(UserRegisterServiceRef ref) =>
    UserRegisterServiceImpl(
        userAuthRepository: ref.watch(userAuthRepositoryProvider),
        userLoginService: ref.watch(userLoginServiceProvider),
        userFirestoreRepository: ref.watch(userFirestoreRepositoryProvider));

@Riverpod(keepAlive: true)
FeedbackFirestoreRepository feedbackFirestoreRepository(
        FeedbackFirestoreRepositoryRef ref) =>
    FeedbackFirestoreRepositoryImpl();

@riverpod
Future<void> logout(LogoutRef ref) async {
  ref.invalidate(userFirestoreRepositoryProvider);
  ref.invalidate(userAuthRepositoryProvider);
  ref.invalidate(spaceFirestoreRepositoryProvider);
  //ref.invalidate(spaceFirestoreRepositoryProvider);
  //ref.invalidate(imagesStorageRepositoryProvider);
  //ref.invalidate(feedbackFirestoreRepositoryProvider);
  //ref.invalidate(reservationFirestoreRepositoryProvider);

  FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut().catchError((_) => null);

  Navigator.of(FestouNavGlobalKey.instance.navKey.currentContext!)
      .pushNamedAndRemoveUntil('/login', (route) => false);
}

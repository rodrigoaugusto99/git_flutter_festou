// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userAuthRepositoryHash() =>
    r'928c0a510eb84398d660286f7df4d21097ccb1fa';

/// See also [userAuthRepository].
@ProviderFor(userAuthRepository)
final userAuthRepositoryProvider = Provider<UserAuthRepository>.internal(
  userAuthRepository,
  name: r'userAuthRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userAuthRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserAuthRepositoryRef = ProviderRef<UserAuthRepository>;
String _$userFirestoreRepositoryHash() =>
    r'4229b69572695b836bb6de88ca8760f4e40a0658';

/// See also [userFirestoreRepository].
@ProviderFor(userFirestoreRepository)
final userFirestoreRepositoryProvider =
    Provider<UserFirestoreRepository>.internal(
  userFirestoreRepository,
  name: r'userFirestoreRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userFirestoreRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserFirestoreRepositoryRef = ProviderRef<UserFirestoreRepository>;
String _$userLoginServiceHash() => r'ff1b56dc64562540a6938511fa2f24b31abef6f5';

/// See also [userLoginService].
@ProviderFor(userLoginService)
final userLoginServiceProvider = Provider<UserLoginService>.internal(
  userLoginService,
  name: r'userLoginServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userLoginServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserLoginServiceRef = ProviderRef<UserLoginService>;
String _$userRegisterServiceHash() =>
    r'c322f1a7303dbac31f6754f7fbc6ad83b4a23797';

/// See also [userRegisterService].
@ProviderFor(userRegisterService)
final userRegisterServiceProvider = Provider<UserRegisterService>.internal(
  userRegisterService,
  name: r'userRegisterServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRegisterServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRegisterServiceRef = ProviderRef<UserRegisterService>;
String _$spaceFirestoreRepositoryHash() =>
    r'675ddba674e078685a05ad64044a5fbc51b25096';

/// See also [spaceFirestoreRepository].
@ProviderFor(spaceFirestoreRepository)
final spaceFirestoreRepositoryProvider =
    Provider<SpaceFirestoreRepository>.internal(
  spaceFirestoreRepository,
  name: r'spaceFirestoreRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$spaceFirestoreRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SpaceFirestoreRepositoryRef = ProviderRef<SpaceFirestoreRepository>;
String _$logoutHash() => r'9e943065799eddf9201be58b762ca1f1f18240d6';

/// See also [logout].
@ProviderFor(logout)
final logoutProvider = AutoDisposeFutureProvider<void>.internal(
  logout,
  name: r'logoutProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$logoutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LogoutRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter

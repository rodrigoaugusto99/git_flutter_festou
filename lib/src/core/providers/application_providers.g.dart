// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'fc805b8c0a1f46135347a9db62f5a10a35a1756c';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = Provider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRepositoryRef = ProviderRef<UserRepository>;
String _$userLoginServiceHash() => r'62431221aac8e45888e74928ecf0b5836e72b999';

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
    r'c85df047d6a170102661fc74b879d70dedf84458';

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
String _$spaceRepositoryHash() => r'588d1fe1e8c9ea054f58e7d2ce8033e347abe089';

/// See also [spaceRepository].
@ProviderFor(spaceRepository)
final spaceRepositoryProvider = Provider<SpaceRepository>.internal(
  spaceRepository,
  name: r'spaceRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$spaceRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SpaceRepositoryRef = ProviderRef<SpaceRepository>;
String _$logoutHash() => r'a12611e887f1f50de1d87924702299b573e9f52c';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

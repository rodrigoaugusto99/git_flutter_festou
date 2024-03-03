// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_my_reservations_info_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$showMyReservationsInfosVmHash() =>
    r'4e430366a33d1ee3b2b000d6dbd5da9561ac858e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ShowMyReservationsInfosVm
    extends BuildlessAutoDisposeAsyncNotifier<ShowMyReservationsInfosState> {
  late final String userId;

  Future<ShowMyReservationsInfosState> build(
    String userId,
  );
}

/// See also [ShowMyReservationsInfosVm].
@ProviderFor(ShowMyReservationsInfosVm)
const showMyReservationsInfosVmProvider = ShowMyReservationsInfosVmFamily();

/// See also [ShowMyReservationsInfosVm].
class ShowMyReservationsInfosVmFamily
    extends Family<AsyncValue<ShowMyReservationsInfosState>> {
  /// See also [ShowMyReservationsInfosVm].
  const ShowMyReservationsInfosVmFamily();

  /// See also [ShowMyReservationsInfosVm].
  ShowMyReservationsInfosVmProvider call(
    String userId,
  ) {
    return ShowMyReservationsInfosVmProvider(
      userId,
    );
  }

  @visibleForOverriding
  @override
  ShowMyReservationsInfosVmProvider getProviderOverride(
    covariant ShowMyReservationsInfosVmProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'showMyReservationsInfosVmProvider';
}

/// See also [ShowMyReservationsInfosVm].
class ShowMyReservationsInfosVmProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ShowMyReservationsInfosVm,
        ShowMyReservationsInfosState> {
  /// See also [ShowMyReservationsInfosVm].
  ShowMyReservationsInfosVmProvider(
    String userId,
  ) : this._internal(
          () => ShowMyReservationsInfosVm()..userId = userId,
          from: showMyReservationsInfosVmProvider,
          name: r'showMyReservationsInfosVmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$showMyReservationsInfosVmHash,
          dependencies: ShowMyReservationsInfosVmFamily._dependencies,
          allTransitiveDependencies:
              ShowMyReservationsInfosVmFamily._allTransitiveDependencies,
          userId: userId,
        );

  ShowMyReservationsInfosVmProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Future<ShowMyReservationsInfosState> runNotifierBuild(
    covariant ShowMyReservationsInfosVm notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(ShowMyReservationsInfosVm Function() create) {
    return ProviderOverride(
      origin: this,
      override: ShowMyReservationsInfosVmProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  (String,) get argument {
    return (userId,);
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ShowMyReservationsInfosVm,
      ShowMyReservationsInfosState> createElement() {
    return _ShowMyReservationsInfosVmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShowMyReservationsInfosVmProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ShowMyReservationsInfosVmRef
    on AutoDisposeAsyncNotifierProviderRef<ShowMyReservationsInfosState> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _ShowMyReservationsInfosVmProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ShowMyReservationsInfosVm,
        ShowMyReservationsInfosState> with ShowMyReservationsInfosVmRef {
  _ShowMyReservationsInfosVmProviderElement(super.provider);

  @override
  String get userId => (origin as ShowMyReservationsInfosVmProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package

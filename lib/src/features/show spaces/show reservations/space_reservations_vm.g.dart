// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_reservations_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$spaceReservationsVmHash() =>
    r'9783e08f0c04ad951d0e55473aded19b3ded3a94';

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

abstract class _$SpaceReservationsVm
    extends BuildlessAutoDisposeAsyncNotifier<SpaceReservationsState> {
  late final SpaceModel space;

  Future<SpaceReservationsState> build(
    SpaceModel space,
  );
}

/// See also [SpaceReservationsVm].
@ProviderFor(SpaceReservationsVm)
const spaceReservationsVmProvider = SpaceReservationsVmFamily();

/// See also [SpaceReservationsVm].
class SpaceReservationsVmFamily
    extends Family<AsyncValue<SpaceReservationsState>> {
  /// See also [SpaceReservationsVm].
  const SpaceReservationsVmFamily();

  /// See also [SpaceReservationsVm].
  SpaceReservationsVmProvider call(
    SpaceModel space,
  ) {
    return SpaceReservationsVmProvider(
      space,
    );
  }

  @visibleForOverriding
  @override
  SpaceReservationsVmProvider getProviderOverride(
    covariant SpaceReservationsVmProvider provider,
  ) {
    return call(
      provider.space,
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
  String? get name => r'spaceReservationsVmProvider';
}

/// See also [SpaceReservationsVm].
class SpaceReservationsVmProvider extends AutoDisposeAsyncNotifierProviderImpl<
    SpaceReservationsVm, SpaceReservationsState> {
  /// See also [SpaceReservationsVm].
  SpaceReservationsVmProvider(
    SpaceModel space,
  ) : this._internal(
          () => SpaceReservationsVm()..space = space,
          from: spaceReservationsVmProvider,
          name: r'spaceReservationsVmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$spaceReservationsVmHash,
          dependencies: SpaceReservationsVmFamily._dependencies,
          allTransitiveDependencies:
              SpaceReservationsVmFamily._allTransitiveDependencies,
          space: space,
        );

  SpaceReservationsVmProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.space,
  }) : super.internal();

  final SpaceModel space;

  @override
  Future<SpaceReservationsState> runNotifierBuild(
    covariant SpaceReservationsVm notifier,
  ) {
    return notifier.build(
      space,
    );
  }

  @override
  Override overrideWith(SpaceReservationsVm Function() create) {
    return ProviderOverride(
      origin: this,
      override: SpaceReservationsVmProvider._internal(
        () => create()..space = space,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        space: space,
      ),
    );
  }

  @override
  (SpaceModel,) get argument {
    return (space,);
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SpaceReservationsVm,
      SpaceReservationsState> createElement() {
    return _SpaceReservationsVmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SpaceReservationsVmProvider && other.space == space;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, space.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SpaceReservationsVmRef
    on AutoDisposeAsyncNotifierProviderRef<SpaceReservationsState> {
  /// The parameter `space` of this provider.
  SpaceModel get space;
}

class _SpaceReservationsVmProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SpaceReservationsVm,
        SpaceReservationsState> with SpaceReservationsVmRef {
  _SpaceReservationsVmProviderElement(super.provider);

  @override
  SpaceModel get space => (origin as SpaceReservationsVmProvider).space;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_card_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$spaceCardVmHash() => r'c75d89829c4cad4088b2f0db2aed4736a1b42e62';

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

abstract class _$SpaceCardVm
    extends BuildlessAutoDisposeAsyncNotifier<SpaceCardState> {
  late final SpaceModel space;

  Future<SpaceCardState> build(
    SpaceModel space,
  );
}

/// See also [SpaceCardVm].
@ProviderFor(SpaceCardVm)
const spaceCardVmProvider = SpaceCardVmFamily();

/// See also [SpaceCardVm].
class SpaceCardVmFamily extends Family<AsyncValue<SpaceCardState>> {
  /// See also [SpaceCardVm].
  const SpaceCardVmFamily();

  /// See also [SpaceCardVm].
  SpaceCardVmProvider call(
    SpaceModel space,
  ) {
    return SpaceCardVmProvider(
      space,
    );
  }

  @override
  SpaceCardVmProvider getProviderOverride(
    covariant SpaceCardVmProvider provider,
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
  String? get name => r'spaceCardVmProvider';
}

/// See also [SpaceCardVm].
class SpaceCardVmProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SpaceCardVm, SpaceCardState> {
  /// See also [SpaceCardVm].
  SpaceCardVmProvider(
    SpaceModel space,
  ) : this._internal(
          () => SpaceCardVm()..space = space,
          from: spaceCardVmProvider,
          name: r'spaceCardVmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$spaceCardVmHash,
          dependencies: SpaceCardVmFamily._dependencies,
          allTransitiveDependencies:
              SpaceCardVmFamily._allTransitiveDependencies,
          space: space,
        );

  SpaceCardVmProvider._internal(
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
  Future<SpaceCardState> runNotifierBuild(
    covariant SpaceCardVm notifier,
  ) {
    return notifier.build(
      space,
    );
  }

  @override
  Override overrideWith(SpaceCardVm Function() create) {
    return ProviderOverride(
      origin: this,
      override: SpaceCardVmProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<SpaceCardVm, SpaceCardState>
      createElement() {
    return _SpaceCardVmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SpaceCardVmProvider && other.space == space;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, space.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SpaceCardVmRef on AutoDisposeAsyncNotifierProviderRef<SpaceCardState> {
  /// The parameter `space` of this provider.
  SpaceModel get space;
}

class _SpaceCardVmProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SpaceCardVm, SpaceCardState>
    with SpaceCardVmRef {
  _SpaceCardVmProviderElement(super.provider);

  @override
  SpaceModel get space => (origin as SpaceCardVmProvider).space;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter

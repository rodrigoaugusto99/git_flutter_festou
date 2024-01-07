// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaces_with_sugestion_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$spacesWithSugestionVmHash() =>
    r'4614da2b136f247f83baa302ee1d5fe4b69226c4';

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

abstract class _$SpacesWithSugestionVm
    extends BuildlessAutoDisposeAsyncNotifier<SpacesWithSugestionState> {
  late final SpaceModel spaceModel;

  Future<SpacesWithSugestionState> build(
    SpaceModel spaceModel,
  );
}

/// See also [SpacesWithSugestionVm].
@ProviderFor(SpacesWithSugestionVm)
const spacesWithSugestionVmProvider = SpacesWithSugestionVmFamily();

/// See also [SpacesWithSugestionVm].
class SpacesWithSugestionVmFamily
    extends Family<AsyncValue<SpacesWithSugestionState>> {
  /// See also [SpacesWithSugestionVm].
  const SpacesWithSugestionVmFamily();

  /// See also [SpacesWithSugestionVm].
  SpacesWithSugestionVmProvider call(
    SpaceModel spaceModel,
  ) {
    return SpacesWithSugestionVmProvider(
      spaceModel,
    );
  }

  @override
  SpacesWithSugestionVmProvider getProviderOverride(
    covariant SpacesWithSugestionVmProvider provider,
  ) {
    return call(
      provider.spaceModel,
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
  String? get name => r'spacesWithSugestionVmProvider';
}

/// See also [SpacesWithSugestionVm].
class SpacesWithSugestionVmProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SpacesWithSugestionVm,
        SpacesWithSugestionState> {
  /// See also [SpacesWithSugestionVm].
  SpacesWithSugestionVmProvider(
    SpaceModel spaceModel,
  ) : this._internal(
          () => SpacesWithSugestionVm()..spaceModel = spaceModel,
          from: spacesWithSugestionVmProvider,
          name: r'spacesWithSugestionVmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$spacesWithSugestionVmHash,
          dependencies: SpacesWithSugestionVmFamily._dependencies,
          allTransitiveDependencies:
              SpacesWithSugestionVmFamily._allTransitiveDependencies,
          spaceModel: spaceModel,
        );

  SpacesWithSugestionVmProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.spaceModel,
  }) : super.internal();

  final SpaceModel spaceModel;

  @override
  Future<SpacesWithSugestionState> runNotifierBuild(
    covariant SpacesWithSugestionVm notifier,
  ) {
    return notifier.build(
      spaceModel,
    );
  }

  @override
  Override overrideWith(SpacesWithSugestionVm Function() create) {
    return ProviderOverride(
      origin: this,
      override: SpacesWithSugestionVmProvider._internal(
        () => create()..spaceModel = spaceModel,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        spaceModel: spaceModel,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SpacesWithSugestionVm,
      SpacesWithSugestionState> createElement() {
    return _SpacesWithSugestionVmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SpacesWithSugestionVmProvider &&
        other.spaceModel == spaceModel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, spaceModel.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SpacesWithSugestionVmRef
    on AutoDisposeAsyncNotifierProviderRef<SpacesWithSugestionState> {
  /// The parameter `spaceModel` of this provider.
  SpaceModel get spaceModel;
}

class _SpacesWithSugestionVmProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SpacesWithSugestionVm,
        SpacesWithSugestionState> with SpacesWithSugestionVmRef {
  _SpacesWithSugestionVmProviderElement(super.provider);

  @override
  SpaceModel get spaceModel =>
      (origin as SpacesWithSugestionVmProvider).spaceModel;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter

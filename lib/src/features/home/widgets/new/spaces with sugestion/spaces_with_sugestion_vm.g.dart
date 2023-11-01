// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaces_with_sugestion_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$spacesWithSugestionVmHash() =>
    r'f1e739df289442e1e76e0bac68120d1bfa0e352e';

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
  late final SpaceWithImages spaceWithImages;

  Future<SpacesWithSugestionState> build(
    SpaceWithImages spaceWithImages,
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
    SpaceWithImages spaceWithImages,
  ) {
    return SpacesWithSugestionVmProvider(
      spaceWithImages,
    );
  }

  @override
  SpacesWithSugestionVmProvider getProviderOverride(
    covariant SpacesWithSugestionVmProvider provider,
  ) {
    return call(
      provider.spaceWithImages,
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
    SpaceWithImages spaceWithImages,
  ) : this._internal(
          () => SpacesWithSugestionVm()..spaceWithImages = spaceWithImages,
          from: spacesWithSugestionVmProvider,
          name: r'spacesWithSugestionVmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$spacesWithSugestionVmHash,
          dependencies: SpacesWithSugestionVmFamily._dependencies,
          allTransitiveDependencies:
              SpacesWithSugestionVmFamily._allTransitiveDependencies,
          spaceWithImages: spaceWithImages,
        );

  SpacesWithSugestionVmProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.spaceWithImages,
  }) : super.internal();

  final SpaceWithImages spaceWithImages;

  @override
  Future<SpacesWithSugestionState> runNotifierBuild(
    covariant SpacesWithSugestionVm notifier,
  ) {
    return notifier.build(
      spaceWithImages,
    );
  }

  @override
  Override overrideWith(SpacesWithSugestionVm Function() create) {
    return ProviderOverride(
      origin: this,
      override: SpacesWithSugestionVmProvider._internal(
        () => create()..spaceWithImages = spaceWithImages,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        spaceWithImages: spaceWithImages,
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
        other.spaceWithImages == spaceWithImages;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, spaceWithImages.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SpacesWithSugestionVmRef
    on AutoDisposeAsyncNotifierProviderRef<SpacesWithSugestionState> {
  /// The parameter `spaceWithImages` of this provider.
  SpaceWithImages get spaceWithImages;
}

class _SpacesWithSugestionVmProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SpacesWithSugestionVm,
        SpacesWithSugestionState> with SpacesWithSugestionVmRef {
  _SpacesWithSugestionVmProviderElement(super.provider);

  @override
  SpaceWithImages get spaceWithImages =>
      (origin as SpacesWithSugestionVmProvider).spaceWithImages;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter

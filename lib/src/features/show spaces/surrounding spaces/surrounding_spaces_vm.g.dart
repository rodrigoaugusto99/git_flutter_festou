// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surrounding_spaces_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$surroundingSpacesVmHash() =>
    r'1cc9c509675e475ce9bfd0124ff08c760827f7d1';

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

abstract class _$SurroundingSpacesVm
    extends BuildlessAutoDisposeAsyncNotifier<SurroundingSpacesState> {
  late final LatLngBounds bounds;

  Future<SurroundingSpacesState> build(
    LatLngBounds bounds,
  );
}

/// See also [SurroundingSpacesVm].
@ProviderFor(SurroundingSpacesVm)
const surroundingSpacesVmProvider = SurroundingSpacesVmFamily();

/// See also [SurroundingSpacesVm].
class SurroundingSpacesVmFamily
    extends Family<AsyncValue<SurroundingSpacesState>> {
  /// See also [SurroundingSpacesVm].
  const SurroundingSpacesVmFamily();

  /// See also [SurroundingSpacesVm].
  SurroundingSpacesVmProvider call(
    LatLngBounds bounds,
  ) {
    return SurroundingSpacesVmProvider(
      bounds,
    );
  }

  @visibleForOverriding
  @override
  SurroundingSpacesVmProvider getProviderOverride(
    covariant SurroundingSpacesVmProvider provider,
  ) {
    return call(
      provider.bounds,
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
  String? get name => r'surroundingSpacesVmProvider';
}

/// See also [SurroundingSpacesVm].
class SurroundingSpacesVmProvider extends AutoDisposeAsyncNotifierProviderImpl<
    SurroundingSpacesVm, SurroundingSpacesState> {
  /// See also [SurroundingSpacesVm].
  SurroundingSpacesVmProvider(
    LatLngBounds bounds,
  ) : this._internal(
          () => SurroundingSpacesVm()..bounds = bounds,
          from: surroundingSpacesVmProvider,
          name: r'surroundingSpacesVmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$surroundingSpacesVmHash,
          dependencies: SurroundingSpacesVmFamily._dependencies,
          allTransitiveDependencies:
              SurroundingSpacesVmFamily._allTransitiveDependencies,
          bounds: bounds,
        );

  SurroundingSpacesVmProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bounds,
  }) : super.internal();

  final LatLngBounds bounds;

  @override
  Future<SurroundingSpacesState> runNotifierBuild(
    covariant SurroundingSpacesVm notifier,
  ) {
    return notifier.build(
      bounds,
    );
  }

  @override
  Override overrideWith(SurroundingSpacesVm Function() create) {
    return ProviderOverride(
      origin: this,
      override: SurroundingSpacesVmProvider._internal(
        () => create()..bounds = bounds,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bounds: bounds,
      ),
    );
  }

  @override
  (LatLngBounds,) get argument {
    return (bounds,);
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SurroundingSpacesVm,
      SurroundingSpacesState> createElement() {
    return _SurroundingSpacesVmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SurroundingSpacesVmProvider && other.bounds == bounds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bounds.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SurroundingSpacesVmRef
    on AutoDisposeAsyncNotifierProviderRef<SurroundingSpacesState> {
  /// The parameter `bounds` of this provider.
  LatLngBounds get bounds;
}

class _SurroundingSpacesVmProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SurroundingSpacesVm,
        SurroundingSpacesState> with SurroundingSpacesVmRef {
  _SurroundingSpacesVmProviderElement(super.provider);

  @override
  LatLngBounds get bounds => (origin as SurroundingSpacesVmProvider).bounds;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package

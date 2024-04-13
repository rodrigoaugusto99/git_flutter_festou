// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaces_by_type_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$spacesByTypeVmHash() => r'c74756af98e21a9602eade222b825263d81b3fac';

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

abstract class _$SpacesByTypeVm
    extends BuildlessAutoDisposeAsyncNotifier<SpacesByTypeState> {
  late final List<String> type;

  Future<SpacesByTypeState> build(
    List<String> type,
  );
}

/// See also [SpacesByTypeVm].
@ProviderFor(SpacesByTypeVm)
const spacesByTypeVmProvider = SpacesByTypeVmFamily();

/// See also [SpacesByTypeVm].
class SpacesByTypeVmFamily extends Family<AsyncValue<SpacesByTypeState>> {
  /// See also [SpacesByTypeVm].
  const SpacesByTypeVmFamily();

  /// See also [SpacesByTypeVm].
  SpacesByTypeVmProvider call(
    List<String> type,
  ) {
    return SpacesByTypeVmProvider(
      type,
    );
  }

  @visibleForOverriding
  @override
  SpacesByTypeVmProvider getProviderOverride(
    covariant SpacesByTypeVmProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'spacesByTypeVmProvider';
}

/// See also [SpacesByTypeVm].
class SpacesByTypeVmProvider extends AutoDisposeAsyncNotifierProviderImpl<
    SpacesByTypeVm, SpacesByTypeState> {
  /// See also [SpacesByTypeVm].
  SpacesByTypeVmProvider(
    List<String> type,
  ) : this._internal(
          () => SpacesByTypeVm()..type = type,
          from: spacesByTypeVmProvider,
          name: r'spacesByTypeVmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$spacesByTypeVmHash,
          dependencies: SpacesByTypeVmFamily._dependencies,
          allTransitiveDependencies:
              SpacesByTypeVmFamily._allTransitiveDependencies,
          type: type,
        );

  SpacesByTypeVmProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final List<String> type;

  @override
  Future<SpacesByTypeState> runNotifierBuild(
    covariant SpacesByTypeVm notifier,
  ) {
    return notifier.build(
      type,
    );
  }

  @override
  Override overrideWith(SpacesByTypeVm Function() create) {
    return ProviderOverride(
      origin: this,
      override: SpacesByTypeVmProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  (List<String>,) get argument {
    return (type,);
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SpacesByTypeVm, SpacesByTypeState>
      createElement() {
    return _SpacesByTypeVmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SpacesByTypeVmProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SpacesByTypeVmRef
    on AutoDisposeAsyncNotifierProviderRef<SpacesByTypeState> {
  /// The parameter `type` of this provider.
  List<String> get type;
}

class _SpacesByTypeVmProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SpacesByTypeVm,
        SpacesByTypeState> with SpacesByTypeVmRef {
  _SpacesByTypeVmProviderElement(super.provider);

  @override
  List<String> get type => (origin as SpacesByTypeVmProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_feedbacks_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$spaceFeedbacksVmHash() => r'6087ae0861e0f6aed5b940cbb0aa33f3647bb25d';

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

abstract class _$SpaceFeedbacksVm
    extends BuildlessAutoDisposeAsyncNotifier<SpaceFeedbacksState> {
  late final SpaceModel space;
  late final String filter;

  Future<SpaceFeedbacksState> build(
    SpaceModel space,
    String filter,
  );
}

/// See also [SpaceFeedbacksVm].
@ProviderFor(SpaceFeedbacksVm)
const spaceFeedbacksVmProvider = SpaceFeedbacksVmFamily();

/// See also [SpaceFeedbacksVm].
class SpaceFeedbacksVmFamily extends Family<AsyncValue<SpaceFeedbacksState>> {
  /// See also [SpaceFeedbacksVm].
  const SpaceFeedbacksVmFamily();

  /// See also [SpaceFeedbacksVm].
  SpaceFeedbacksVmProvider call(
    SpaceModel space,
    String filter,
  ) {
    return SpaceFeedbacksVmProvider(
      space,
      filter,
    );
  }

  @visibleForOverriding
  @override
  SpaceFeedbacksVmProvider getProviderOverride(
    covariant SpaceFeedbacksVmProvider provider,
  ) {
    return call(
      provider.space,
      provider.filter,
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
  String? get name => r'spaceFeedbacksVmProvider';
}

/// See also [SpaceFeedbacksVm].
class SpaceFeedbacksVmProvider extends AutoDisposeAsyncNotifierProviderImpl<
    SpaceFeedbacksVm, SpaceFeedbacksState> {
  /// See also [SpaceFeedbacksVm].
  SpaceFeedbacksVmProvider(
    SpaceModel space,
    String filter,
  ) : this._internal(
          () => SpaceFeedbacksVm()
            ..space = space
            ..filter = filter,
          from: spaceFeedbacksVmProvider,
          name: r'spaceFeedbacksVmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$spaceFeedbacksVmHash,
          dependencies: SpaceFeedbacksVmFamily._dependencies,
          allTransitiveDependencies:
              SpaceFeedbacksVmFamily._allTransitiveDependencies,
          space: space,
          filter: filter,
        );

  SpaceFeedbacksVmProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.space,
    required this.filter,
  }) : super.internal();

  final SpaceModel space;
  final String filter;

  @override
  Future<SpaceFeedbacksState> runNotifierBuild(
    covariant SpaceFeedbacksVm notifier,
  ) {
    return notifier.build(
      space,
      filter,
    );
  }

  @override
  Override overrideWith(SpaceFeedbacksVm Function() create) {
    return ProviderOverride(
      origin: this,
      override: SpaceFeedbacksVmProvider._internal(
        () => create()
          ..space = space
          ..filter = filter,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        space: space,
        filter: filter,
      ),
    );
  }

  @override
  (
    SpaceModel,
    String,
  ) get argument {
    return (
      space,
      filter,
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SpaceFeedbacksVm, SpaceFeedbacksState>
      createElement() {
    return _SpaceFeedbacksVmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SpaceFeedbacksVmProvider &&
        other.space == space &&
        other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, space.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SpaceFeedbacksVmRef
    on AutoDisposeAsyncNotifierProviderRef<SpaceFeedbacksState> {
  /// The parameter `space` of this provider.
  SpaceModel get space;

  /// The parameter `filter` of this provider.
  String get filter;
}

class _SpaceFeedbacksVmProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SpaceFeedbacksVm,
        SpaceFeedbacksState> with SpaceFeedbacksVmRef {
  _SpaceFeedbacksVmProviderElement(super.provider);

  @override
  SpaceModel get space => (origin as SpaceFeedbacksVmProvider).space;
  @override
  String get filter => (origin as SpaceFeedbacksVmProvider).filter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package

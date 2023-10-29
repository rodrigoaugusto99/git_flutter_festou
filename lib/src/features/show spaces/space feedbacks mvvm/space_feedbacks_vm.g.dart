// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_feedbacks_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$spaceFeedbacksVmHash() => r'fb86cd816627cfaf3f8cdc0c5a315ef879f87014';

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

  Future<SpaceFeedbacksState> build(
    SpaceModel space,
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
  ) {
    return SpaceFeedbacksVmProvider(
      space,
    );
  }

  @override
  SpaceFeedbacksVmProvider getProviderOverride(
    covariant SpaceFeedbacksVmProvider provider,
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
  String? get name => r'spaceFeedbacksVmProvider';
}

/// See also [SpaceFeedbacksVm].
class SpaceFeedbacksVmProvider extends AutoDisposeAsyncNotifierProviderImpl<
    SpaceFeedbacksVm, SpaceFeedbacksState> {
  /// See also [SpaceFeedbacksVm].
  SpaceFeedbacksVmProvider(
    SpaceModel space,
  ) : this._internal(
          () => SpaceFeedbacksVm()..space = space,
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
        );

  SpaceFeedbacksVmProvider._internal(
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
  Future<SpaceFeedbacksState> runNotifierBuild(
    covariant SpaceFeedbacksVm notifier,
  ) {
    return notifier.build(
      space,
    );
  }

  @override
  Override overrideWith(SpaceFeedbacksVm Function() create) {
    return ProviderOverride(
      origin: this,
      override: SpaceFeedbacksVmProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<SpaceFeedbacksVm, SpaceFeedbacksState>
      createElement() {
    return _SpaceFeedbacksVmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SpaceFeedbacksVmProvider && other.space == space;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, space.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SpaceFeedbacksVmRef
    on AutoDisposeAsyncNotifierProviderRef<SpaceFeedbacksState> {
  /// The parameter `space` of this provider.
  SpaceModel get space;
}

class _SpaceFeedbacksVmProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SpaceFeedbacksVm,
        SpaceFeedbacksState> with SpaceFeedbacksVmRef {
  _SpaceFeedbacksVmProviderElement(super.provider);

  @override
  SpaceModel get space => (origin as SpaceFeedbacksVmProvider).space;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter

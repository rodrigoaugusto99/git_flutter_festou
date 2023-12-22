// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meus_feedbacks_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$meusFeedbacksVmHash() => r'208e3d8d3c66a318d031c81e3785d7513536063d';

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

abstract class _$MeusFeedbacksVm
    extends BuildlessAutoDisposeAsyncNotifier<MeusFeedbacksState> {
  late final String userId;

  Future<MeusFeedbacksState> build(
    String userId,
  );
}

/// See also [MeusFeedbacksVm].
@ProviderFor(MeusFeedbacksVm)
const meusFeedbacksVmProvider = MeusFeedbacksVmFamily();

/// See also [MeusFeedbacksVm].
class MeusFeedbacksVmFamily extends Family<AsyncValue<MeusFeedbacksState>> {
  /// See also [MeusFeedbacksVm].
  const MeusFeedbacksVmFamily();

  /// See also [MeusFeedbacksVm].
  MeusFeedbacksVmProvider call(
    String userId,
  ) {
    return MeusFeedbacksVmProvider(
      userId,
    );
  }

  @override
  MeusFeedbacksVmProvider getProviderOverride(
    covariant MeusFeedbacksVmProvider provider,
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
  String? get name => r'meusFeedbacksVmProvider';
}

/// See also [MeusFeedbacksVm].
class MeusFeedbacksVmProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MeusFeedbacksVm, MeusFeedbacksState> {
  /// See also [MeusFeedbacksVm].
  MeusFeedbacksVmProvider(
    String userId,
  ) : this._internal(
          () => MeusFeedbacksVm()..userId = userId,
          from: meusFeedbacksVmProvider,
          name: r'meusFeedbacksVmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$meusFeedbacksVmHash,
          dependencies: MeusFeedbacksVmFamily._dependencies,
          allTransitiveDependencies:
              MeusFeedbacksVmFamily._allTransitiveDependencies,
          userId: userId,
        );

  MeusFeedbacksVmProvider._internal(
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
  Future<MeusFeedbacksState> runNotifierBuild(
    covariant MeusFeedbacksVm notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(MeusFeedbacksVm Function() create) {
    return ProviderOverride(
      origin: this,
      override: MeusFeedbacksVmProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<MeusFeedbacksVm, MeusFeedbacksState>
      createElement() {
    return _MeusFeedbacksVmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MeusFeedbacksVmProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MeusFeedbacksVmRef
    on AutoDisposeAsyncNotifierProviderRef<MeusFeedbacksState> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _MeusFeedbacksVmProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MeusFeedbacksVm,
        MeusFeedbacksState> with MeusFeedbacksVmRef {
  _MeusFeedbacksVmProviderElement(super.provider);

  @override
  String get userId => (origin as MeusFeedbacksVmProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter

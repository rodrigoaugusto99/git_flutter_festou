// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minhas_avaliacoes_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$minhasAvaliacoesVmHash() =>
    r'208e3d8d3c66a318d031c81e3785d7513536063d';

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

abstract class _$MinhasAvaliacoesVm
    extends BuildlessAutoDisposeAsyncNotifier<MinhasAvaliacoesState> {
  late final String userId;

  Future<MinhasAvaliacoesState> build(
    String userId,
  );
}

/// See also [MinhasAvaliacoesVm].
@ProviderFor(MinhasAvaliacoesVm)
const meusFeedbacksVmProvider = MinhasAvaliacoesVmFamily();

/// See also [MinhasAvaliacoesVm].
class MinhasAvaliacoesVmFamily
    extends Family<AsyncValue<MinhasAvaliacoesState>> {
  /// See also [MinhasAvaliacoesVm].
  const MinhasAvaliacoesVmFamily();

  /// See also [MinhasAvaliacoesVm].
  MinhasAvaliacoesVmProvider call(
    String userId,
  ) {
    return MinhasAvaliacoesVmProvider(
      userId,
    );
  }

  @visibleForOverriding
  @override
  MinhasAvaliacoesVmProvider getProviderOverride(
    covariant MinhasAvaliacoesVmProvider provider,
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

/// See also [MinhasAvaliacoesVm].
class MinhasAvaliacoesVmProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MinhasAvaliacoesVm, MinhasAvaliacoesState> {
  /// See also [MinhasAvaliacoesVm].
  MinhasAvaliacoesVmProvider(
    String userId,
  ) : this._internal(
          () => MinhasAvaliacoesVm()..userId = userId,
          from: meusFeedbacksVmProvider,
          name: r'meusFeedbacksVmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$minhasAvaliacoesVmHash,
          dependencies: MinhasAvaliacoesVmFamily._dependencies,
          allTransitiveDependencies:
              MinhasAvaliacoesVmFamily._allTransitiveDependencies,
          userId: userId,
        );

  MinhasAvaliacoesVmProvider._internal(
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
  Future<MinhasAvaliacoesState> runNotifierBuild(
    covariant MinhasAvaliacoesVm notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(MinhasAvaliacoesVm Function() create) {
    return ProviderOverride(
      origin: this,
      override: MinhasAvaliacoesVmProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<MinhasAvaliacoesVm,
      MinhasAvaliacoesState> createElement() {
    return _MinhasAvaliacoesVmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MinhasAvaliacoesVmProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MinhasAvaliacoesVmRef
    on AutoDisposeAsyncNotifierProviderRef<MinhasAvaliacoesState> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _MinhasAvaliacoesVmProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MinhasAvaliacoesVm,
        MinhasAvaliacoesState> with MinhasAvaliacoesVmRef {
  _MinhasAvaliacoesVmProviderElement(super.provider);

  @override
  String get userId => (origin as MinhasAvaliacoesVmProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package

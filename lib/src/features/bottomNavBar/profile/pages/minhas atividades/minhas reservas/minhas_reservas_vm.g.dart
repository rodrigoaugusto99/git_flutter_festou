// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minhas_reservas_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$minhasReservasVmHash() => r'a14fb8ffe895471c3c93243275fd71e1a42d78ab';

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

abstract class _$MinhasReservasVm
    extends BuildlessAutoDisposeAsyncNotifier<MinhasReservasState> {
  late final String userId;

  Future<MinhasReservasState> build(
    String userId,
  );
}

/// See also [MinhasReservasVm].
@ProviderFor(MinhasReservasVm)
const minhasReservasVmProvider = MinhasReservasVmFamily();

/// See also [MinhasReservasVm].
class MinhasReservasVmFamily extends Family<AsyncValue<MinhasReservasState>> {
  /// See also [MinhasReservasVm].
  const MinhasReservasVmFamily();

  /// See also [MinhasReservasVm].
  MinhasReservasVmProvider call(
    String userId,
  ) {
    return MinhasReservasVmProvider(
      userId,
    );
  }

  @visibleForOverriding
  @override
  MinhasReservasVmProvider getProviderOverride(
    covariant MinhasReservasVmProvider provider,
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
  String? get name => r'minhasReservasVmProvider';
}

/// See also [MinhasReservasVm].
class MinhasReservasVmProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MinhasReservasVm, MinhasReservasState> {
  /// See also [MinhasReservasVm].
  MinhasReservasVmProvider(
    String userId,
  ) : this._internal(
          () => MinhasReservasVm()..userId = userId,
          from: minhasReservasVmProvider,
          name: r'minhasReservasVmProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$minhasReservasVmHash,
          dependencies: MinhasReservasVmFamily._dependencies,
          allTransitiveDependencies:
              MinhasReservasVmFamily._allTransitiveDependencies,
          userId: userId,
        );

  MinhasReservasVmProvider._internal(
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
  Future<MinhasReservasState> runNotifierBuild(
    covariant MinhasReservasVm notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(MinhasReservasVm Function() create) {
    return ProviderOverride(
      origin: this,
      override: MinhasReservasVmProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<MinhasReservasVm, MinhasReservasState>
      createElement() {
    return _MinhasReservasVmProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MinhasReservasVmProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MinhasReservasVmRef
    on AutoDisposeAsyncNotifierProviderRef<MinhasReservasState> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _MinhasReservasVmProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MinhasReservasVm,
        MinhasReservasState> with MinhasReservasVmRef {
  _MinhasReservasVmProviderElement(super.provider);

  @override
  String get userId => (origin as MinhasReservasVmProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'informacoes_pessoais_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$informacoesPessoaisVMHash() =>
    r'11d45e35b8eb47deb6215e236dd549105e587331';

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

abstract class _$InformacoesPessoaisVM
    extends BuildlessAutoDisposeAsyncNotifier<InformacoesPessoaisState> {
  late final String text;
  late final String newText;

  Future<InformacoesPessoaisState> build(
    String text,
    String newText,
  );
}

/// See also [InformacoesPessoaisVM].
@ProviderFor(InformacoesPessoaisVM)
const informacoesPessoaisVMProvider = InformacoesPessoaisVMFamily();

/// See also [InformacoesPessoaisVM].
class InformacoesPessoaisVMFamily
    extends Family<AsyncValue<InformacoesPessoaisState>> {
  /// See also [InformacoesPessoaisVM].
  const InformacoesPessoaisVMFamily();

  /// See also [InformacoesPessoaisVM].
  InformacoesPessoaisVMProvider call(
    String text,
    String newText,
  ) {
    return InformacoesPessoaisVMProvider(
      text,
      newText,
    );
  }

  @override
  InformacoesPessoaisVMProvider getProviderOverride(
    covariant InformacoesPessoaisVMProvider provider,
  ) {
    return call(
      provider.text,
      provider.newText,
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
  String? get name => r'informacoesPessoaisVMProvider';
}

/// See also [InformacoesPessoaisVM].
class InformacoesPessoaisVMProvider
    extends AutoDisposeAsyncNotifierProviderImpl<InformacoesPessoaisVM,
        InformacoesPessoaisState> {
  /// See also [InformacoesPessoaisVM].
  InformacoesPessoaisVMProvider(
    String text,
    String newText,
  ) : this._internal(
          () => InformacoesPessoaisVM()
            ..text = text
            ..newText = newText,
          from: informacoesPessoaisVMProvider,
          name: r'informacoesPessoaisVMProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$informacoesPessoaisVMHash,
          dependencies: InformacoesPessoaisVMFamily._dependencies,
          allTransitiveDependencies:
              InformacoesPessoaisVMFamily._allTransitiveDependencies,
          text: text,
          newText: newText,
        );

  InformacoesPessoaisVMProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.text,
    required this.newText,
  }) : super.internal();

  final String text;
  final String newText;

  @override
  Future<InformacoesPessoaisState> runNotifierBuild(
    covariant InformacoesPessoaisVM notifier,
  ) {
    return notifier.build(
      text,
      newText,
    );
  }

  @override
  Override overrideWith(InformacoesPessoaisVM Function() create) {
    return ProviderOverride(
      origin: this,
      override: InformacoesPessoaisVMProvider._internal(
        () => create()
          ..text = text
          ..newText = newText,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        text: text,
        newText: newText,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<InformacoesPessoaisVM,
      InformacoesPessoaisState> createElement() {
    return _InformacoesPessoaisVMProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InformacoesPessoaisVMProvider &&
        other.text == text &&
        other.newText == newText;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, text.hashCode);
    hash = _SystemHash.combine(hash, newText.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin InformacoesPessoaisVMRef
    on AutoDisposeAsyncNotifierProviderRef<InformacoesPessoaisState> {
  /// The parameter `text` of this provider.
  String get text;

  /// The parameter `newText` of this provider.
  String get newText;
}

class _InformacoesPessoaisVMProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<InformacoesPessoaisVM,
        InformacoesPessoaisState> with InformacoesPessoaisVMRef {
  _InformacoesPessoaisVMProviderElement(super.provider);

  @override
  String get text => (origin as InformacoesPessoaisVMProvider).text;
  @override
  String get newText => (origin as InformacoesPessoaisVMProvider).newText;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter

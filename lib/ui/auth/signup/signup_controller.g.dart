// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignupController)
final signupControllerProvider = SignupControllerProvider._();

final class SignupControllerProvider
    extends $AsyncNotifierProvider<SignupController, void> {
  SignupControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupControllerHash();

  @$internal
  @override
  SignupController create() => SignupController();
}

String _$signupControllerHash() => r'030be141fe6e5bef9aead64ec68568b53da261a8';

abstract class _$SignupController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

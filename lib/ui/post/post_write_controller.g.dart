// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_write_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostWriteController)
final postWriteControllerProvider = PostWriteControllerProvider._();

final class PostWriteControllerProvider
    extends $AsyncNotifierProvider<PostWriteController, void> {
  PostWriteControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postWriteControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postWriteControllerHash();

  @$internal
  @override
  PostWriteController create() => PostWriteController();
}

String _$postWriteControllerHash() =>
    r'729f79ed556157625f15bfc3a9d81bb2014d67c1';

abstract class _$PostWriteController extends $AsyncNotifier<void> {
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

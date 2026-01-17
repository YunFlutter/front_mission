// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_delete_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostDeleteController)
final postDeleteControllerProvider = PostDeleteControllerProvider._();

final class PostDeleteControllerProvider
    extends $AsyncNotifierProvider<PostDeleteController, void> {
  PostDeleteControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postDeleteControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postDeleteControllerHash();

  @$internal
  @override
  PostDeleteController create() => PostDeleteController();
}

String _$postDeleteControllerHash() =>
    r'd6db5aa87f6cbf2ebf2beb662ec54ef33353df7a';

abstract class _$PostDeleteController extends $AsyncNotifier<void> {
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_edit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostEditController)
final postEditControllerProvider = PostEditControllerProvider._();

final class PostEditControllerProvider
    extends $AsyncNotifierProvider<PostEditController, void> {
  PostEditControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postEditControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postEditControllerHash();

  @$internal
  @override
  PostEditController create() => PostEditController();
}

String _$postEditControllerHash() =>
    r'1c761539f6ce36f818d6589286101ad43095f988';

abstract class _$PostEditController extends $AsyncNotifier<void> {
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

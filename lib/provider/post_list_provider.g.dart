// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostListController)
final postListControllerProvider = PostListControllerProvider._();

final class PostListControllerProvider
    extends $NotifierProvider<PostListController, PostListState> {
  PostListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postListControllerHash();

  @$internal
  @override
  PostListController create() => PostListController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostListState>(value),
    );
  }
}

String _$postListControllerHash() =>
    r'37e952e97f9c1498972a57f101a3e6a6dcc74f3f';

abstract class _$PostListController extends $Notifier<PostListState> {
  PostListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PostListState, PostListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostListState, PostListState>,
              PostListState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

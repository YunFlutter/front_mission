// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(postDetail)
final postDetailProvider = PostDetailFamily._();

final class PostDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<PostDetail>,
          PostDetail,
          FutureOr<PostDetail>
        >
    with $FutureModifier<PostDetail>, $FutureProvider<PostDetail> {
  PostDetailProvider._({
    required PostDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'postDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postDetailHash();

  @override
  String toString() {
    return r'postDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PostDetail> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<PostDetail> create(Ref ref) {
    final argument = this.argument as int;
    return postDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PostDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postDetailHash() => r'd2b1b62a346b029946d09c641181dabb4ff31336';

final class PostDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PostDetail>, int> {
  PostDetailFamily._()
    : super(
        retry: null,
        name: r'postDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostDetailProvider call(int postId) =>
      PostDetailProvider._(argument: postId, from: this);

  @override
  String toString() => r'postDetailProvider';
}

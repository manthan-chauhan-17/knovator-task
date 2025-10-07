import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:knovator_task/service/api_service/api.dart';
import 'package:knovator_task/service/storage_service/hive_helper.dart';
import 'package:knovator_task/model/posts_model.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    on<GetPostsEvent>(_onGetPosts);
    on<FilterPostsEvent>(_onFilterPosts);
    on<MarkPostAsReadEvent>(_onMarkPostAsRead);
  }

  FutureOr<void> _onGetPosts(
    GetPostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    final cached = HiveHelper.getAllPosts();
    final currentFiler = state is PostsLoaded
        ? (state as PostsLoaded).activeFilter
        : "All";

    if (cached.isNotEmpty) {
      final readIds = _getReadPostIds(cached);
      emit(PostsLoaded(cached, readPostIds: readIds));
    } else {
      emit(PostsLoading());
    }

    try {
      final List<PostsModel> fresh = await Api.getPosts();
      await HiveHelper.savePosts(fresh);
      final readIds = _getReadPostIds(fresh);
      emit(
        PostsLoaded(fresh, activeFilter: currentFiler, readPostIds: readIds),
      );
    } catch (e) {
      if (cached.isEmpty) {
        emit(PostsError(e.toString()));
      }
    }
  }

  Set<int> _getReadPostIds(List<PostsModel> posts) {
    return posts
        .where((post) => HiveHelper.isPostRead(post.id ?? -1))
        .map((post) => post.id ?? -1)
        .toSet();
  }

  void _onFilterPosts(FilterPostsEvent event, Emitter<PostsState> emit) {
    if (state is PostsLoaded) {
      final loadedState = state as PostsLoaded;
      final readIds = _getReadPostIds(loadedState.posts);
      emit(
        PostsLoaded(
          loadedState.posts,
          activeFilter: event.filter,
          readPostIds: readIds,
        ),
      );
    }
  }

  Future<void> _onMarkPostAsRead(
    MarkPostAsReadEvent event,
    Emitter<PostsState> emit,
  ) async {
    if (state is PostsLoaded) {
      final loadedState = state as PostsLoaded;
      await HiveHelper.markPostAsRead(event.postId);

      // Create a new set with the newly read post ID
      final updatedReadIds = {...loadedState.readPostIds, event.postId};

      emit(
        PostsLoaded(
          loadedState.posts,
          activeFilter: loadedState.activeFilter,
          readPostIds: updatedReadIds,
        ),
      );
    }
  }
}

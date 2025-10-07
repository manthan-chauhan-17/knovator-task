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
      emit(PostsLoaded(cached));
    } else {
      emit(PostsLoading());
    }

    try {
      final List<PostsModel> fresh = await Api.getPosts();
      await HiveHelper.savePosts(fresh);
      emit(PostsLoaded(fresh, activeFilter: currentFiler));
    } catch (e) {
      if (cached.isEmpty) {
        emit(PostsError(e.toString()));
      }
    }
  }

  void _onFilterPosts(FilterPostsEvent event, Emitter<PostsState> emit) {
    if (state is PostsLoaded) {
      final loadedState = state as PostsLoaded;
      emit(PostsLoaded(loadedState.posts, activeFilter: event.filter));
    }
  }

  Future<void> _onMarkPostAsRead(
    MarkPostAsReadEvent event,
    Emitter<PostsState> emit,
  ) async {
    if (state is PostsLoaded) {
      final loadedState = state as PostsLoaded;
      await HiveHelper.markPostAsRead(event.postId);

      emit(
        PostsLoaded(loadedState.posts, activeFilter: loadedState.activeFilter),
      );
    }
  }
}

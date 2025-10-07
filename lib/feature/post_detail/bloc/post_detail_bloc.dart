import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:knovator_task/service/api_service/api.dart';
import 'package:knovator_task/service/storage_service/hive_helper.dart';
import 'package:knovator_task/model/posts_model.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc() : super(PostDetailInitial()) {
    on<GetPostEvent>(_onGetPost);
  }

  FutureOr<void> _onGetPost(
    GetPostEvent event,
    Emitter<PostDetailState> emit,
  ) async {
    final cached = HiveHelper.getPost(event.id);
    if (cached != null) {
      emit(PostDetailLoaded(cached));
    } else {
      emit(PostDetailLoading());
    }

    try {
      final PostsModel fresh = await Api.getPost(event.id);
      await HiveHelper.savePost(fresh);
      emit(PostDetailLoaded(fresh));
    } catch (e) {
      if (cached == null) {
        emit(PostDetailError(e.toString()));
      }
    }
  }
}

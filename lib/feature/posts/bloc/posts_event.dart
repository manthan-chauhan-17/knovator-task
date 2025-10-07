part of 'posts_bloc.dart';

sealed class PostsEvent extends Equatable {}

class GetPostsEvent extends PostsEvent {
  @override
  List<Object?> get props => [];
}

class FilterPostsEvent extends PostsEvent {
  final String filter;
  FilterPostsEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class MarkPostAsReadEvent extends PostsEvent {
  final int postId;
  MarkPostAsReadEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

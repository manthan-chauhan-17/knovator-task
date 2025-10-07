part of 'posts_bloc.dart';

sealed class PostsState extends Equatable {}

final class PostsInitial extends PostsState {
  @override
  List<Object?> get props => [];
}

class PostsLoading extends PostsState {
  @override
  List<Object?> get props => [];
}

class PostsLoaded extends PostsState {
  final List<PostsModel> posts;
  final String activeFilter;
  PostsLoaded(this.posts, {this.activeFilter = 'All'});

  @override
  List<Object?> get props => [posts, activeFilter];
}

class PostsError extends PostsState {
  final String message;
  PostsError(this.message);

  @override
  List<Object?> get props => [message];
}

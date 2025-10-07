part of 'post_detail_bloc.dart';

sealed class PostDetailState extends Equatable {}

final class PostDetailInitial extends PostDetailState {
  @override
  List<Object?> get props => [];
}

final class PostDetailLoaded extends PostDetailState {
  final PostsModel post;
  PostDetailLoaded(this.post);

  @override
  List<Object?> get props => [post];
}

final class PostDetailError extends PostDetailState {
  final String message;
  PostDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

final class PostDetailLoading extends PostDetailState {
  @override
  List<Object?> get props => [];
}

part of 'post_detail_bloc.dart';

sealed class PostDetailEvent extends Equatable {}

class GetPostEvent extends PostDetailEvent {
  final int id;
  GetPostEvent(this.id);

  @override
  List<Object?> get props => [id];
}

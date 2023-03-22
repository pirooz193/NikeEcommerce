part of 'comment_list_bloc_bloc.dart';

abstract class CommentListState extends Equatable {
  const CommentListState();

  @override
  List<Object> get props => [];
}

class CommentListLoading extends CommentListState {}

class CommentListSucsses extends CommentListState {
  final List<CommentEntity> comments;

  CommentListSucsses(this.comments);

  @override
  // TODO: implement props
  List<Object> get props => [comments];
}

class CommentListError extends CommentListState {
  final AppException exception;

  CommentListError(this.exception);

  @override
  // TODO: implement props
  List<Object> get props => [exception];
}

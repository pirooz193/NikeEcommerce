import 'package:dio/dio.dart';
import 'package:nike_ecommerce_flutter/data/comment.dart';
import 'package:nike_ecommerce_flutter/data/common/http_response_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required int productId});
}

class CommentRemoteDatasource
    with HttpResponseValidator
    implements ICommentDataSource {
  final Dio httpClient;

  CommentRemoteDatasource(this.httpClient);

  @override
  Future<List<CommentEntity>> getAll({required int productId}) async {
    final response = await httpClient.get('comment/list?product_id=$productId');
    validateResponse(response);
    final List<CommentEntity> comments = [];
    (response.data as List).forEach((element) {
      comments.add(CommentEntity.fromJson(element));
    });
    return comments;
  }
}

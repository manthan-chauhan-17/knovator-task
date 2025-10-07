import 'package:dio/dio.dart';
import 'package:knovator_task/model/posts_model.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: '')
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET('/posts')
  Future<List<PostsModel>> getPosts();

  @GET('/posts/{id}')
  Future<PostsModel> getPost(@Path('id') int id);
}

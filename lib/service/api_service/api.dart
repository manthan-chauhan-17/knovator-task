import 'dart:developer';

import 'package:knovator_task/service/api_service/injection.dart';
import 'package:knovator_task/model/posts_model.dart';

class Api {
  static Future<List<PostsModel>> getPosts() async {
    try {
      List<PostsModel> posts = await restClient.getPosts();
      return posts;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<PostsModel> getPost(int id) async {
    try {
      PostsModel post = await restClient.getPost(id);
      return post;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

import 'package:hive_flutter/hive_flutter.dart';
import 'package:knovator_task/service/storage_service/posts_hive_model.dart';
import 'package:knovator_task/model/posts_model.dart';

class HiveHelper {
  static const String postsBoxName = 'posts_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PostsHiveModelAdapter());
    }
    await Hive.openBox<PostsHiveModel>(postsBoxName);
  }

  static Box<PostsHiveModel> get _postsBox =>
      Hive.box<PostsHiveModel>(postsBoxName);

  static List<PostsModel> getAllPosts() {
    return _postsBox.values
        .map((e) => e.toPostsModel())
        .toList(growable: false);
  }

  static Future<void> savePosts(List<PostsModel> posts) async {
    await _postsBox.clear();
    final Map<dynamic, PostsHiveModel> entries = <dynamic, PostsHiveModel>{};
    for (final post in posts) {
      final key = post.id ?? DateTime.now().millisecondsSinceEpoch;
      final existing = _postsBox.get(key);
      final isRead = existing?.isRead ?? false;
      entries[key] = PostsHiveModel.fromPostsModel(post, isRead: isRead);
    }
    await _postsBox.putAll(entries);
  }

  static PostsModel? getPost(int id) {
    final direct = _postsBox.get(id);
    if (direct != null) return direct.toPostsModel();
    for (final post in _postsBox.values) {
      if (post.id == id) return post.toPostsModel();
    }
    return null;
  }

  static Future<void> savePost(PostsModel post) async {
    final key = post.id ?? DateTime.now().millisecondsSinceEpoch;
    final existing = _postsBox.get(key);
    final isRead = existing?.isRead ?? false;
    await _postsBox.put(
      key,
      PostsHiveModel.fromPostsModel(post, isRead: isRead),
    );
  }

  static bool isPostRead(int id) {
    final direct = _postsBox.get(id);
    if (direct != null) return direct.isRead;
    for (final e in _postsBox.values) {
      if (e.id == id) {
        return e.isRead;
      }
    }
    return false;
  }

  static Future<void> markPostAsRead(int id) async {
    final direct = _postsBox.get(id);
    if (direct != null) {
      await _postsBox.put(id, direct.copyWith(isRead: true));
      return;
    }
    final key = _postsBox.keys.firstWhere(
      (k) => (_postsBox.get(k)?.id) == id,
      orElse: () => id,
    );
    final item = _postsBox.get(key);
    if (item != null) {
      await _postsBox.put(key, item.copyWith(isRead: true));
    }
  }
}

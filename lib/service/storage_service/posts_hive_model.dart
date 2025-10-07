import 'package:hive/hive.dart';
import 'package:knovator_task/model/posts_model.dart';

@HiveType(typeId: 1)
class PostsHiveModel {
  @HiveField(0)
  final int? userId;

  @HiveField(1)
  final int? id;

  @HiveField(2)
  final String? title;

  @HiveField(3)
  final String? body;

  @HiveField(4)
  final bool isRead;

  const PostsHiveModel({
    this.userId,
    this.id,
    this.title,
    this.body,
    this.isRead = false,
  });

  factory PostsHiveModel.fromPostsModel(
    PostsModel model, {
    bool isRead = false,
  }) => PostsHiveModel(
    userId: model.userId,
    id: model.id,
    title: model.title,
    body: model.body,
    isRead: isRead,
  );

  PostsModel toPostsModel() =>
      PostsModel(userId: userId, id: id, title: title, body: body);

  PostsHiveModel copyWith({bool? isRead}) => PostsHiveModel(
    userId: userId,
    id: id,
    title: title,
    body: body,
    isRead: isRead ?? this.isRead,
  );
}

class PostsHiveModelAdapter extends TypeAdapter<PostsHiveModel> {
  @override
  final int typeId = 1;

  @override
  PostsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return PostsHiveModel(
      userId: fields[0] as int?,
      id: fields[1] as int?,
      title: fields[2] as String?,
      body: fields[3] as String?,
      isRead: (fields[4] as bool?) ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, PostsHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.isRead);
  }
}
